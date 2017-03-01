class HousingUnit::SidebarCell < ::IndexCell
  property :housing_facility

  def show
    h4 strong link_to(housing_facility.name, housing_facility_path(housing_facility))
  end
end
