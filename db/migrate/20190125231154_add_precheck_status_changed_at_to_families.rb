class AddPrecheckStatusChangedAtToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :precheck_status_changed_at, :datetime
    add_index :families, :precheck_status_changed_at
  end
end
