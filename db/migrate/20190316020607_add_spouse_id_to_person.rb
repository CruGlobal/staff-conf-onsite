class AddSpouseIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :spouse_id, :integer
    add_index :people, :spouse_id
  end
end
