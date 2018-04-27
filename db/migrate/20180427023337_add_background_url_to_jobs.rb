class AddBackgroundUrlToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :background_url, :string
  end
end
