class HousingFacility::SidebarCell < ::IndexCell
  property :housing_facility

  def show
    h4 strong link_to("All Units (#{housing_facility.housing_units.size})",
                      housing_facility_housing_units_path(housing_facility))
    h4 strong 'Recently Changed'

    units_list
  end

  private

  def units_list
    ul class: 'units_list' do
      housing_facility.housing_units.order(updated_at: :desc).map do |r|
        li link_to(r.name,
                   housing_facility_housing_unit_path(housing_facility, r.id))
      end
    end
  end
end
