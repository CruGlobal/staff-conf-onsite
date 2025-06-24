class AddArrivalScannedToFamilies < ActiveRecord::Migration[7.1]
  def change
    add_column :families, :arrival_scanned, :boolean
  end
end
