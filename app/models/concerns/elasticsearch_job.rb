module ElasticsearchJob
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    after_commit on: [:create, :update] do
      create_or_update_index
    end

    after_commit on: :destroy do
      if Elasticsearch.elasticsearch_enable? && __elasticsearch__.client.transport.connections.present?
        __elasticsearch__.delete_document rescue nil
      end
    end

    def create_or_update_index(reindex = false)
      if Elasticsearch.elasticsearch_enable? &&
         __elasticsearch__.client.transport.connections.present? &&
         after_publish?
        if (status_previously_changed? && available?) || (viewable_previously_changed? && viewable)
          __elasticsearch__.index_document
        elsif viewable_previously_changed? && !viewable
          __elasticsearch__.delete_document rescue nil
        else
          begin
            if organizer_id_previously_changed? || staff_id_previously_changed? || manager_id_previously_changed? || area_id_previously_changed? || start_at_previously_changed?
              __elasticsearch__.index_document
            elsif reindex
              __elasticsearch__.index_document
            else
              __elasticsearch__.update_document
            end
          rescue
            __elasticsearch__.index_document
          end
        end
      end
    rescue => e
      logger.error(e)
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
        }
       }
      }
    } do
      mappings dynamic: 'false', _all: {enabled: false} do
        indexes :id, type: 'integer', index: true
        indexes :title, type: 'text', index: true, boost: 5, fielddata: true
        indexes :description, type: 'text', index: true, boost: 2, fielddata: true, analyzer: 'job_analyzer'
        indexes :about_candidate, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer'
        indexes :location, type: 'text', index: true, fielddata: true
        indexes :job_type, type: 'text', index: true, fielddata: true
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
      jobs_ids = []
      jobs_score = []
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
      location_filter = {
        filter: {
          match: {
            location: {
              query: location,
              fuzziness: "AUTO"
            }
          }
        },
        weight: 2
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
      job_type_filter = {
        filter: {
          match: {
            job_type: {
              query: job_type,
              fuzziness: "AUTO"
            }
          }
        },
        weight: 2
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
      tag_boost_filter.push(view_count_filter)
      tag_boost_filter.push(location_filter)
      tag_boost_filter.push(salary_filter)
      tag_boost_filter.push(job_type_filter)
      {
        size: size,
        query: {
          function_score: {
            query: {
              multi_match: {
                query: keyword_match,
                fuzziness: "AUTO",
                fields: ["title", "about_candidate", "description"]
              }
            },
            functions: tag_boost_filter
          }
        },
        highlight: {
          pre_tags: ["<strong>"],
          post_tags: ["</strong>"],
          fields: {
            description: {}
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
        tags.push(keyword[:key])
      end
      tags
    rescue => e
      Rails.logger.error(e)
      {
        tags: []
      }
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
                  field: "about_candidate"
                }
              }
            }
          }
        }
      }
    end
  end
end