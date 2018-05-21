class Message < ApplicationRecord
  after_create_commit :message_notify
  belongs_to :user
  belongs_to :conversation, touch: true
  enum message_type: {normal: 0, suggest_link: 1, interview_invite: 2}

  def message_notify
    user = self.user
    MessageBroadcastJob.perform_later(user.conversations.unread_conversations.count, self)
  end
end
