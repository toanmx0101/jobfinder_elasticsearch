class RemoveFieldFromApplies < ActiveRecord::Migration[5.1]
  def change
    remove_column :applies, :create
    remove_column :applies, :destroy
    add_column :applies, :applyer_id, :integer
    add_column :applies, :job_id, :integer
  end
end
