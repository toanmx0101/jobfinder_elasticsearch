class AddInterviewIdToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :interviews, :interview_id, :integer
  end
end
