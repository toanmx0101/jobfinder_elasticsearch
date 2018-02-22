class AddOtherFieldToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :user_id, :integer
    add_column :articles, :location, :string
    add_column :articles, :company_id, :integer
    add_column :articles, :experience_level, :string
    add_column :articles, :language, :string
    add_column :articles, :job_type, :string
    add_column :articles, :pay_rate, :string
  end
end
