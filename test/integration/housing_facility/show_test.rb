require 'test_helper'

class HousingFacility::ShowTest < IntegrationTest
  before do
    @user = create_login_user
    @housing_facility = create :housing_facility
  end

  test '#show details' do
    visit housing_facility_path(@housing_facility)

    assert_selector '#page_title', text: @housing_facility.name

    within('.panel', text: 'Housing Facility Details') do
      assert_show_rows :id, :name, :housing_type, :cost_code, :cafeteria,
                       :city, :state, :street, :zip, :created_at, :updated_at, 
                       selector: "#attributes_table_housing_facility_#{@housing_facility.id}"
    end
  end
end