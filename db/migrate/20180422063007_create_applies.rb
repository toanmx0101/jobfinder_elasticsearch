class CreateApplies < ActiveRecord::Migration[5.1]
  def change
    create_table :applies do |t|
      t.string :create
      t.string :destroy

      t.timestamps
    end
  end
end
