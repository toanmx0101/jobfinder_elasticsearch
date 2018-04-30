class Apply < ApplicationRecord
  belongs_to :job
  belongs_to :applyer, class_name: "User"

  validates :job_id, uniqueness: { scope: :applyer_id }
end
