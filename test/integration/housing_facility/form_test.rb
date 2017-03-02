require 'test_helper'

class HousingFacility::FormTest < IntegrationTest
  before do
    @user = create_login_user
    @housing_facility = create :housing_facility_with_units
  end

  test '#edit fields' do
    visit edit_housing_facility_path(@housing_facility)

    assert_edit_fields :name, :housing_type, :cost_code_id, :cafeteria,
                       :street, :city, :state, :zip, :country_code,
                       record: @housing_facility

    assert_active_admin_comments
  end

  test '#new record creation' do
    enable_javascript!
    login_user(@user)

    attrs = attributes_for :housing_facility

    visit new_housing_facility_path

    assert_difference ['HousingFacility.count'] do
      within('form#new_housing_facility') do
        # details
        fill_in 'Name',     with: attrs[:name]
        select_option('Housing type')
        # select_option('Cost code')
        fill_in 'Cafeteria', with: attrs[:cafeteria]

        # address
        fill_in 'Street',   with: attrs[:street]
        fill_in 'City',     with: attrs[:city]
        fill_in 'State',    with: attrs[:state]
        fill_in 'Zip Code', with: attrs[:zip]
        select_option('Country')
      end

      click_button 'Create Housing facility'
      assert_selector('body.show.housing_facilities')
    end
  end
end
