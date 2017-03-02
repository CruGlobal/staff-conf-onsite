require 'test_helper'

class HousingFacility::SidebarTest < IntegrationTest
  before do
    @user = create_login_user
    @housing_facility = create :housing_facility_with_units
  end

  test '#sidebar on show page' do
    visit housing_facility_path(@housing_facility)
    units_sidebar
  end

  test '#sidebar on edit page' do
    visit edit_housing_facility_path(@housing_facility)
    units_sidebar
  end

  private

  def units_sidebar
    within('#units_sidebar_section') do
      assert_selector('h4 strong a',
                     text: "All Units (#{@housing_facility.housing_units.size})")

      assert_selector('ul.units_list li a', 
                     text: @housing_facility.housing_units.sample.name)
    end
  end
end
