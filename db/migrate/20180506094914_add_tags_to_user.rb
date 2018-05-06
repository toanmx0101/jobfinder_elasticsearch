class AddTagsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tags, :string
  end
end
