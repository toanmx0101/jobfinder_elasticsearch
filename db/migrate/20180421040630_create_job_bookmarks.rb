class CreateJobBookmarks < ActiveRecord::Migration[5.1]
  def change
    create_table :job_bookmarks do |t|
      t.integer :job_id, null: false
      t.integer :user_id, null: false

      t.index [:user_id, :job_id]
      t.timestamps
    end
  end
end
