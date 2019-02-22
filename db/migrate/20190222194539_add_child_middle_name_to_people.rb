class AddChildMiddleNameToPeople < ActiveRecord::Migration
  def change
    add_column :people, :child_middle_name, :string
    add_index :people, :child_middle_name
  end
end
