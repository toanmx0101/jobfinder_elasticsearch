class AddViewHistoryToUser < ActiveRecord::Migration[5.1]
  def change
  	add_column :users, :view_history, :string
  end
end
