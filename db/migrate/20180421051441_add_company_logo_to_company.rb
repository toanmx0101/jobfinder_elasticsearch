class AddCompanyLogoToCompany < ActiveRecord::Migration[5.1]
  def change
  	add_column :companies, :company_logo, :string
  end
end
