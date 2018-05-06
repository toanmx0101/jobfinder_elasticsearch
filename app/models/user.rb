class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :jobs, dependent: :destroy
  has_many :notifications, dependent: :destroy, class_name: "Notification", foreign_key: "recipient_id"
  has_many :applies, class_name: "Apply", foreign_key: "applyer_id"

  serialize :view_history
  serialize :tags

  extend FriendlyId
  friendly_id :username

  def is_recruiter?
  	return self.user_type == "recruiter"
  end

  def have_recruitment?(job)
    return self.jobs.include?(job)
  end
end
