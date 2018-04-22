class RemoveEventFromNotification < ActiveRecord::Migration[5.1]
  def change
    remove_column :notifications, :event
  end
end
