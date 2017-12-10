class AddWorkPositionToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :work_position, :string
  end
end
