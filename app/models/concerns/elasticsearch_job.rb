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
          english_analyzer: {
          type: "english",
          tokenizer: "whitespace",
          stopwords: "_english_",
          filter: [
            "lowercase",
            "type_as_payload"
          ]
        }
       }
      }
    } do
      mappings dynamic: 'false', _all: {enabled: false} do
        indexes :id, type: 'integer', index: true
        indexes :title, type: 'text', index: true, boost: 3, fielddata: true
        indexes :description, type: 'text', index: true, boost: 2, fielddata: true
        indexes :about_candidate, type: 'text', index: true, boost: 3, fielddata: true
        indexes :location, type: 'text', index: true
        indexes :view_count, type: 'text', index: true
      end
    end

    def self.create_index!(name:)
      client = __elasticsearch__.client

      client.indices.create(
        index: name,
        body: {settings: settings.to_hash, mappings: mappings.to_hash}
      )
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

    def self.search_el(page, limit, location, tags = [], keyword_match = nil)
      page = page.to_i
      from = (page > 0 ? page - 1 : page) * limit
      search_definition = create_query(from, limit, location, tags, keyword_match)
      res = search_elasticsearch(search_definition)
      res[:from] = from
      res
    end

    def self.search_elasticsearch(search_definition)
      response = __elasticsearch__.search(search_definition)
      hits = response.to_a
      jobs_ids = []
      hits.each do |elm|
        jobs_ids.push(elm.id)
      end
      body = if jobs_ids.present?
               Job.where(id: jobs_ids)
             else
               []
             end
      {
        body: body,
        total: response.results.total
      }
    rescue => e
      Rails.logger.error(e)
      {
        body: [],
        total: 0
      }
    end

    def self.create_query(from, size, location, tags = [], keyword_match = nil)
      view_count_filter ={
         filter: {
            range: {
              view_count: {
                from: 0
              }
            }
          }, 
          script_score: {
            script: "_score + Math.log(doc.view_count.value)"
          }
      }

      {
        size: size,
        query: {
          function_score: {
            query: {
              multi_match: {
                query: keyword_match,
                fields: [ "title", "about_candidate", "description", "location" ]
              } 
            },
            functions: [
              {
                filter: { 
                  match: { 
                    about_candidate: tags[0][:term]
                  }
                },
                weight: tags[0][:boost]
              },
              {
                filter: { 
                  match: { 
                    about_candidate: tags[1][:term]
                  }
                },
                weight: tags[1][:boost]
              },
              {
                filter: {
                  range: {
                    view_count: {
                      from: 0
                    }
                  }
                }, 
                script_score: {
                  script: "_score + Math.log(doc.view_count.value)"
                }
              }
            ],
          }
        }
      }
    end
  end
end