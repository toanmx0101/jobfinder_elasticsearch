class AddOrtherColumnToNotification < ActiveRecord::Migration[5.1]
  def change
    add_column :notifications, :recipient_id, :integer
    add_column :notifications, :actor_id, :integer
    add_column :notifications, :read_at, :datetime
    add_column :notifications, :action, :string
    add_column :notifications, :notifiable_id, :integer
    add_column :notifications, :notifiable_type, :string
  end
end
