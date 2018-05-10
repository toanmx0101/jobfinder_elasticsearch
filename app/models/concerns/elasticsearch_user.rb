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
    # nêu ra vấn đề tìm kiếm  phuonwg pháp, 
    # chương 2 tổng quan hệ thống thành phần yêu cầu chức ăng. 
    # implement explement, solution exprementtation   neu ra ket qua dua ra cac truwong hop
    # kết luận

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
        indexes :experience_and_skill, type: 'text', index: true, boost: 3, fielddata: true, analyzer: 'job_analyzer'
        indexes :location, type: 'text', index: true, fielddata: true
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
        experience_and_skill: experience_and_skill,
        location: location,
        view_count: view_count
      }

      job_attrs
    end
  end
end
