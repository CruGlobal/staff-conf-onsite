class AddPositionToHousingFacilities < ActiveRecord::Migration[7.1]
  def change
    add_column :housing_facilities, :position, :integer

    HousingFacility.order(:updated_at).each.with_index(1) do |record, index|
      record.update_column :position, index
    end
  end
end
