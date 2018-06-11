class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :applyer, class_name: "User"

  validates :job_id, uniqueness: { scope: :applyer_id }

  PER_PAGE = 6
  paginates_per PER_PAGE
end
