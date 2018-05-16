class AddStatusColumnToConversations < ActiveRecord::Migration[5.1]
  def change
    add_column :conversations, :status, :string
  end
end
