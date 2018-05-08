class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.string :title
      t.string :description
      t.integer :recruiter_id
      t.integer :interviewer_id
      t.integer :job_id
      t.datetime :start_at
      t.string :duration
      t.string :status
      t.timestamps
    end
  end
end
