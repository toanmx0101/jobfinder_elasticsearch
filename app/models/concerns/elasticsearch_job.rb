module ElasticsearchJob
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit on: [:create] do
      __elasticsearch__.index_document
    end

    after_commit on: [:update] do
      __elasticsearch__.update_document
    end

    after_commit on: :destroy do
      if Elasticsearch.elasticsearch_enable? && __elasticsearch__.client.transport.connections.present?
        __elasticsearch__.delete_document rescue nil
      end
    end

    index_name "jobs"

    settings index: {
      number_of_shards: 1,
      number_of_replicas: 0,
      analysis: {
        analyzer: {
          job_analyzer: {
            type: "standard",
            tokenizer: "whitespace",
            stopwords: "_english_",
            char_filter:  [ "html_strip", "lowercase" ]
          },
          location_analyzer: {
            tokenizer: "location_tokenizer"
          },
          job_type_analyzer: {
            tokenizer: "keyword"
          }
        },
        tokenizer: {
          location_tokenizer: {
            type: "pattern",
            pattern: "(, )|,"
          }
        }
      }
    } do
      mappings dynamic: 'false', _all: {enabled: false} do
        indexes :id, type: 'integer', index: true
        indexes :title, type: 'text', index: true, boost: 5, fielddata: true
        indexes :description, type: 'text', index: true, boost: 2, fielddata: true, analyzer: 'job_analyzer'
        indexes :about_candidate, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer'
        indexes :location, type: 'text', index: true, fielddata: true, analyzer: 'location_analyzer'
        indexes :job_type, type: 'text', index: true, fielddata: true, analyzer: 'job_type_analyzer'
        indexes :view_count, type: 'integer'
      end
    end

    def self.create_index!(name:)
      client = __elasticsearch__.client

      client.indices.delete index: name
      client.indices.create(
        index: name,
        body: {settings: settings.to_hash, mappings: mappings.to_hash}
      )
      Job.import
    end

    def as_indexed_json(_options = {})
      job_attrs = {
        id: id,
        title: title,
        description: description,
        about_candidate: about_candidate,
        job_type: job_type,
        location: location,
        view_count: view_count
      }

      job_attrs
    end

    def self.search_el(page, limit, location, job_type, salary, tags = [], keyword_match = nil)
      page = page.to_i
      from = (page > 0 ? page - 1 : page) * limit
      search_definition = create_query(from, limit, location, job_type, salary, tags, keyword_match)
      res = search_elasticsearch(search_definition)
      res[:from] = from
      res
    end

    def self.search_elasticsearch(search_definition)
      response = __elasticsearch__.search(search_definition)
      hits = response.to_a
      common_locations = []
      response.aggregations.locations.buckets.each do |location|
        common_locations.push(location)
      end
      common_job_types = []
      response.aggregations.job_types.buckets.each do |job_type|
        common_job_types.push(job_type)
      end
      jobs_ids = []
      jobs_score = []
      highlight = []
      hits.each do |elm|
        jobs_ids.push(elm.id)
        jobs_score.push({job_id: elm.id, job_score: elm._score})
      end
      body = if jobs_ids.present?
               Job.find(*jobs_ids)
             else
               []
             end
      {
        body: body,
        jobs_score: jobs_score,
        common_locations: common_locations,
        common_job_types: common_job_types,
        total: response.results.total
      }
    rescue => e
      Rails.logger.error(e)
      {
        body: [],
        total: 0
      }
    end

    def self.create_query(from, size, location, job_type, salary, tags = [], keyword_match = nil)
      view_count_filter = {
                  filter: {
                    range: {
                      view_count: {
                        gte: 0
                      }
                    }
                  },
                  script_score: {
                    script: "_score + Math.log(doc.view_count.value)"
                  }
               }
      salary_filter = {
        filter: {
          match: {
            salary: {
              query: salary,
              fuzziness: "AUTO"
            }
          }
        },
        weight: 1
      }
      tag_boost_filter = []
      unless tags.empty?
        tags.each do |tag|
          tag_boost_filter.push({
            filter: { 
              term: { 
                about_candidate: tag[:term]
              }
            },
            weight: tag[:boost]
          })
        end
      end
      match_location =  []
      if location && location.length > 0
        location.each do |lo|
          match_location.push({ 
                                match: { 
                                  location: {
                                    query: lo,
                                    boost: 3
                                  }
                                }
                              })
        end
      end
      match_job_type = {}
      if job_type && job_type.length > 0
        match_job_type = { terms: { job_type: job_type } }
      end
      tag_boost_filter.push(view_count_filter)
      tag_boost_filter.push(salary_filter)
      {
        from: from,
        size: size,
        query: {
          function_score: {
            query: {
              bool: {
                must: [
                  {
                    multi_match: {
                      query: keyword_match,
                      fuzziness: "AUTO",
                      fields: ["title", "about_candidate", "description"]
                    }
                  }
                ],
                filter: [
                  bool: {
                    must: {
                      bool: {
                        should: match_location,
                        must: match_job_type
                      }
                     
                    }
                  }
                ]
              }
            },
            functions: tag_boost_filter
          }
        },
        highlight: {
          pre_tags: ["<strong>"],
          post_tags: ["</strong>"],
          fields: [
            { description: {} },
            { about_candidate: {} },
            { title: {} }
          ]
        },
        aggs: {
          locations: {
            terms: { 
             field: "location",
             size: 10
            }
          },
          job_types: {
            terms: { 
             field: "job_type",
             size: 10
            }
          }
        }
      }
    end

    def self.generate_tags(work_position)
      search_definition = create_query_agg_keywords(work_position)
      res = search_agg_elasticsearch(search_definition)
      res
    end

    def self.search_agg_elasticsearch(search_definition)
      response = __elasticsearch__.search(search_definition)
      keywords = response.aggregations.sample.keywords.buckets
      tags = []
      keywords.each do |keyword|
        tags.push({term: keyword[:key], boost: keyword[:score].round(2)})
      end
      tags
    rescue => e
      Rails.logger.error(e)
      {
        tags: []
      }
    end

    def self.work_position_tags_analyzer(work_position)
      search_definition = {
                            analyzer: 'job_analyzer',
                            text: work_position
                          }
      response = __elasticsearch__.client.indices.analyze(index: Job.index_name, body: search_definition )
      terms = []
      response['tokens'].each do |token|
        terms.push(token['token'])
      end
      terms
    end

    def self.create_query_agg_keywords(work_position)
      {
        query: {
          multi_match: {
            query: work_position,
            fields: [ "description","about_candidate" ]
          }
        },
        size: 2,
        aggs: {
          sample: {
            sampler: {
              shard_size: 2000
            },
            aggs: {
              keywords: {
                significant_terms: {
                  field: "about_candidate",
                  min_doc_count: 20,
                  size: 10,
                  exclude: Job.work_position_tags_analyzer(work_position)
                }
              }
            }
          }
        }
      }
    end
  end
end