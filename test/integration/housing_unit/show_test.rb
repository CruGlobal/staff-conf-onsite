require 'test_helper'

class HousingUnit::ShowTest < IntegrationTest
  before do
    @user = create_login_user
    @housing_facility = create :housing_facility_with_units
    @housing_unit = @housing_facility.housing_units.sample
  end

  test '#show details' do
    navigate_to_unit_show

    within('.panel', text: 'Housing Unit Details') do
      assert_show_rows :id, :name, :housing_facility, :housing_type, :created_at, :updated_at, 
                       selector: "#attributes_table_housing_unit_#{@housing_unit.id}"
    end
  end

  test '#show assignments empty' do
    navigate_to_unit_show

    within('.panel.stays', text: "Assignments (0)") { assert_text 'None' }
  end

  test '#show assignments' do
    stay = create :stay, housing_unit: @housing_unit

    navigate_to_unit_show

    within('.panel.stays', text: "Assignments (#{@housing_unit.stays.size})") do
      assert_selector 'ol li a', text: stay.person.full_name

      dates = "#{stay.arrived_at.strftime('%B %-d')} until #{stay.departed_at.strftime('%B %-d')}"
      assert_text dates
    end
  end

  private

  def navigate_to_unit_show
    visit housing_facility_path(@housing_facility)
    assert_selector 'h2#page_title', text: @housing_facility.name

    click_link @housing_unit.name
    assert_selector '#page_title', text: "#{@housing_facility.name}: Unit #{@housing_unit.name}"
  end
end
