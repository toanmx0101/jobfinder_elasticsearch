class RemoveInterviewIdFromInterview < ActiveRecord::Migration[5.1]
  def change
    remove_column :interviews, :interview_id, :integer
    add_column :messages, :interview_id, :integer
  end
end
