class Notification < ApplicationRecord
	after_create_commit { NotificationBroadcastJob.perform_later(Notification.count,self)}
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, ->{ where read_at: nil }
end
