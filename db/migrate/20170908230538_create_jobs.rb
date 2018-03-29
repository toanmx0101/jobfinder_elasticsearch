class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.text  :about_candidate
      t.string :state
      t.string :location
      t.string :slug
      t.integer :user_id
      t.integer :view_count, default: 0
      t.timestamps
    end
  end
end
