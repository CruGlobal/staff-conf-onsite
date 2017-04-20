class HousingFacility::IndexCell < ::IndexCell
  def show
    selectable_column

    column :name
    column(:housing_type) { |hf| hf.housing_type.titleize }
    column :cost_code
    column :cafeteria
    column :on_campus

    address_columns
    units_column
    timestamp_columns

    actions
  end

  private

  def address_columns
    column :street
    column :city
    column :state
    column(:country_code) { |hf| country_name(hf.country_code) }
    column :zip
  end

  def units_column
    column 'Units' do |hf|
      link_to hf.housing_units.count, housing_facility_housing_units_path(hf)
    end
  end

  def timestamp_columns
    column :created_at
    column :updated_at
  end
end
