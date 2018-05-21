class ChangeMessageTypeInMessage < ActiveRecord::Migration[5.1]
  def change
    change_column :messages, :message_type, :interger
  end
end
