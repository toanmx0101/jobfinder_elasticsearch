class Job < ActiveRecord::Base
	belongs_to :user
 	validates :description, presence: true

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end
