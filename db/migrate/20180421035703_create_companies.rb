class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :website
      t.string :description
      t.string :industry
      t.string :specialities
      t.string :city
      t.string :size

      t.timestamps
    end
  end
end
