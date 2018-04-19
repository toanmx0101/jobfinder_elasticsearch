class AddPayRateToJobs < ActiveRecord::Migration[5.1]
  def change
  	add_column :jobs, :pay_rate, :string
  end
end
