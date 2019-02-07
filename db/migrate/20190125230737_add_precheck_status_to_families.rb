class AddPrecheckStatusToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :precheck_status, :integer, default: 0
    add_index :families, :precheck_status
  end
end
