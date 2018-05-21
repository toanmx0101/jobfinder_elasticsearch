module ElasticsearchUser
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # after_commit on: [:create] do
    #   __elasticsearch__.index_document
    # end

    # after_commit on: [:update] do
    #   __elasticsearch__.update_document
    # end

    # after_commit on: :destroy do
    #   if Elasticsearch.elasticsearch_enable? && __elasticsearch__.client.transport.connections.present?
    #     __elasticsearch__.delete_document rescue nil
    #   end
    # end

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
        }
       }
      }
    } do
      mappings dynamic: 'false', _all: {enabled: false} do
        indexes :id, type: 'integer', index: true
        indexes :description, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer'
        indexes :experience_and_skill, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer'
        indexes :location, type: 'text', index: true, fielddata: true
        indexes :view_count, type: 'integer'
        indexes :experience_level, type: 'integer'
        indexes :language, type: 'text'
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
        experience_and_skill: experience,
        location: location,
        language: language,
        experience_level: experience_level,
        view_count: view_count
      }

      user_attrs
    end

    def self.find_candidates_by_job(job = nil)
      return User.limit(5)
    end

    def self.find_candidates_by_params(username = nil, work_position = nil, candidate_skills = nil)
      return User.limit(10)
    end
  end
end
