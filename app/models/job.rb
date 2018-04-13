class Job < ActiveRecord::Base
  belongs_to :user
  validates :description, presence: true

  include ElasticsearchJob
end
