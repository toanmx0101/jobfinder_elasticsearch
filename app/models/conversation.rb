class Conversation < ApplicationRecord
  has_many :messages
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :receiver, foreign_key: :receiver_id, class_name: "User"

  validates :sender_id, uniqueness: { scope: :receiver_id }
  enum status: [:unread, :read]
  
  scope :unread_conversations,-> { where status: 'unread' }
  scope :read_conversations,-> { where status: 'read' }

  def opposed_user(user)
    user == receiver ? sender : receiver
  end
end
