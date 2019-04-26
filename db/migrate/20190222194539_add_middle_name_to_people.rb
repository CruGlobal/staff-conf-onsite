class AddMiddleNameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :middle_name, :string
    add_index :people, :middle_name
  end
end
