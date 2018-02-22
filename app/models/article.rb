class Article < ActiveRecord::Base
	belongs_to :user
 	validates :user_id, presence: true
 	validates :content, presence: true, length: { maximum: 1000 }

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings  do
    mapping do
      indexes :title, type: 'text', boost: 2
      indexes :content, type: 'text', boost: 1
    end
  end
end
