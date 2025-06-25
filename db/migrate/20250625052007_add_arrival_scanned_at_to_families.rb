class AddArrivalScannedAtToFamilies < ActiveRecord::Migration[7.1]
  def change
    add_column :families, :arrival_scanned_at, :datetime
  end
end
