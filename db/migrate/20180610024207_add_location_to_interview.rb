class AddLocationToInterview < ActiveRecord::Migration[5.1]
  def change
    add_column :interviews, :location, :string
  end
end
