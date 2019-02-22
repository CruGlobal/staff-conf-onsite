class AddChildCountryToPeople < ActiveRecord::Migration
  def change
    add_column :people, :child_country, :string
    add_index :people, :child_country
  end
end
