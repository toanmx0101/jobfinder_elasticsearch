class AddInforToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string
    add_column :users, :phone, :string
    add_column :users, :location, :string
    add_column :users, :user_type, :integer
    add_column :users, :linkedin, :string
    add_column :users, :education, :string
    add_column :users, :description, :string
    add_column :users, :experience, :string
    add_column :users, :language, :string
    add_column :users, :experience_level, :string
    add_column :users, :website, :string
    add_column :users, :subcribe_jobfinder, :boolean
    add_column :users, :work_position, :string
    add_column :users, :view_count, :string
  end
end
