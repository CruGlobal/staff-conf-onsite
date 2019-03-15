class AddCountyToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :county, :string
    add_index :families, :county
  end
end
