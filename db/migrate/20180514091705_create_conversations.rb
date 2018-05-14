class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations do |t|
      t.integer :receiver_id
      t.integer :sender_id

      t.timestamps
    end
    add_index :conversations, :receiver_id
    add_index :conversations, :sender_id
    add_index :conversations, [:receiver_id, :sender_id], unique: true
  end
end
