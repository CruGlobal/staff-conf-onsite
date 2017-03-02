require 'test_helper'

class HousingFacility::IndexTest < IntegrationTest
  before do
    @user = create_login_user
    @housing_facility = create :housing_facility
  end

  test '#index filters' do
    visit housing_facilities_path

    within('.filter_form') do
      assert_text 'Name'
      assert_text 'Cost code'
      assert_text 'Cafeteria'
      assert_text 'Street'
      assert_text 'City'
      assert_text 'State'
      assert_text 'Country'
      assert_text 'Zip Code'
      assert_text 'Created at'
      assert_text 'Updated at'
    end
  end

  test '#index columns' do
    visit housing_facilities_path

    assert_index_columns :selectable, :id, :name, :housing_type, :cost_code,
                         :cafeteria, :street, :city, :state, :country_code, 
                         :zip, :units, :created_at, :updated_at, :actions
  end

  test '#index items' do
    visit housing_facilities_path

    within('#index_table_housing_facilities') do
      assert_selector "#housing_facility_#{@housing_facility.id}"
    end
  end

end
