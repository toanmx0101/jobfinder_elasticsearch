class Job < ActiveRecord::Base
  include ElasticsearchJob
  extend FriendlyId
  acts_as_url :title, url_attribute: :slug, sync: true

  belongs_to :user
  has_many :applies
  has_many :applyers, through: :applies, source: :applyer

  PER_PAGE = 10
  paginates_per PER_PAGE

  scope :order_by, ->(order_culumn, order_type) { reorder(order_culumn + ' ' + order_type) }

  friendly_id :title, use: [:slugged, :finders]

  def to_param
    "#{id}-#{slug}"
  end
end
