class AddOrtherFieldsToMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :user, foreign_key: true
    add_reference :messages, :conversation , foreign_key: true
    add_column :messages, :content, :string
    add_column :messages, :message_type, :string
    add_column :messages, :read_at, :datetime
    add_column :messages, :link, :string
    remove_column :messages, :body, :string
  end
end
