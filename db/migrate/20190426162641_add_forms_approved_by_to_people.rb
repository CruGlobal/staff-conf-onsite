class AddFormsApprovedByToPeople < ActiveRecord::Migration
  def change
    add_column :people, :forms_approved_by, :string
  end
end
