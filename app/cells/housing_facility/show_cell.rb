class HousingFacility::ShowCell < ::ShowCell
  property :housing_facility_id

  def show
    attributes_table do
      row :id
      row :name
      row(:housing_type) { |hf| hf.housing_type.titleize }
      row(:cost_code) { |hf| link_to(hf.cost_code, hf.cost_code) if hf.cost_code }
      row :cafeteria
      address_rows
      timestamp_rows
    end
  end

  private

  def address_rows
    row :city
    row :state
    row :street
    row(:country_code) { |hf| country_name(hf.country_code) }
    row :zip
  end

  def timestamp_rows
    row :created_at
    row :updated_at
  end
end
