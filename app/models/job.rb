class Job < ActiveRecord::Base
  belongs_to :user
  include ElasticsearchJob
  extend FriendlyId

  PER_PAGE = 10
  paginates_per PER_PAGE

  scope :order_by, ->(order_culumn, order_type) { reorder(order_culumn + ' ' + order_type) }

  friendly_id :title, use: [:slugged, :finders]
  acts_as_url :title, url_attribute: :slug, sync: true

  def to_param
    "#{id}-#{slug}"
  end
end
