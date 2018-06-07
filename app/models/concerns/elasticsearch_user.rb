module ElasticsearchUser
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

    index_name "users"

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
          name_analyzer: {
            tokenizer: "name_tokenizer"
          }
        },
        tokenizer: {
          name_tokenizer: {
            type: "pattern",
            pattern: "_|\\."
          }
        }
      }
    } do
      mappings dynamic: 'false', _all: {enabled: false} do
        indexes :id, type: 'integer', index: true
        indexes :username, type: 'text', index: true, fielddata: true, analyzer: 'name_analyzer'
        indexes :description, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer', term_vector: 'with_positions_offsets_payloads'
        indexes :experience, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer', term_vector: 'with_positions_offsets_payloads'
        indexes :location, type: 'text', index: true, fielddata: true
        indexes :view_count, type: 'integer'
        indexes :experience_level, type: 'integer'
        indexes :language, type: 'text'
        indexes :work_position, type: 'text', term_vector: 'with_positions_offsets_payloads'
        indexes :education, type: 'text', analyzer: 'job_analyzer', term_vector: 'with_positions_offsets_payloads'
      end
    end

    def self.create_index!(name:)
      client = __elasticsearch__.client

      client.indices.delete index: name
      client.indices.create(
        index: name,
        body: {settings: settings.to_hash, mappings: mappings.to_hash}
      )
      User.import
    end

    def as_indexed_json(_options = {})
      user_attrs = {
        id: id,
        description: description,
        experience: experience,
        location: location,
        language: language,
        experience_level: experience_level,
        view_count: view_count,
        education: education,
        work_position: work_position,
        username: username
      }

      user_attrs
    end

    def self.find_candidates_by_job(page, limit, job = nil)
      page = page.to_i
      from = (page > 0 ? page - 1 : page) * limit
      search_definition = create_query_by_job(from, limit, job)
      res = search_elasticsearch(search_definition)
      res[:from] = from
      res
    end

    def self.find_candidates_by_params(page, limit, username = nil, work_position = nil, candidate_skills = nil)
      page = page.to_i
      from = (page > 0 ? page - 1 : page) * limit
      search_definition = create_query_by_params(page, limit, username, work_position, candidate_skills)
      res = search_elasticsearch(search_definition)
      res[:from] = from
      res
    end

    def self.search_elasticsearch(search_definition)
      response = __elasticsearch__.search(search_definition)
      hits = response.to_a
      user_ids = []
      user_score = []
      highlight = []
      hits.each do |elm|
        user_ids.push(elm.id)
        user_score.push({user_id: elm.id, user_score: elm._score})
      end
      body = if user_ids.present?
               User.find(*user_ids)
             else
               []
             end
      {
        body: body,
        user_score: user_score,
        total: response.results.total
      }
    rescue => e
      Rails.logger.error(e)
      {
        body: [],
        total: 0
      }
    end

    def self.create_query_by_job(from, size, job)
      {
        from: from,
        size: size,
        query: {
          function_score: {
            query: {
              multi_match: {
                query: job.title,
                fuzziness: "AUTO",
                fields: ["work_position", "experience", "description"]
              }
            },
            functions: []
          }
        },
        highlight: {
          pre_tags: ["<strong>"],
          post_tags: ["</strong>"],
          fields: [
            { work_position: {} },
            { experience: {} }
          ]
        }
      }
    end
    def self.create_query_by_params(from, size, username, work_position, candidate_skills)
      {
        from: from,
        size: size,
        query: {
          function_score: {
            query: {
              bool: {
                should: [
                  {
                    match: {
                      username: {
                        query: username,
                        fuzziness: 3
                      }
                    }
                  },
                  {
                    match: {
                      work_position: {
                        query: work_position,
                        fuzziness: 'AUTO'
                      }
                    }
                  },
                  {
                    match: {
                      experience: {
                        query: candidate_skills,
                        fuzziness: 'AUTO'
                      }
                    }
                  }
                ]
              }
            }
          }
        }
      }
    end
  end

  
end
