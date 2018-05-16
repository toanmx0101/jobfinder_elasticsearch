class Message < ApplicationRecord
  after_create_commit :message_notify
  belongs_to :user
  belongs_to :conversation, touch: true

  def message_notify
    MessageBroadcastJob.perform_later(current.user.conversations.unread_messages.count, self)
  end
end
