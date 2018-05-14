class Message < ApplicationRecord
  after_create_commit :message_notify
  belongs_to :user
  belongs_to :conversation, touch: true

  def message_notify
    MessageBroadcastJob.perform_later(1, self)
  end
end
