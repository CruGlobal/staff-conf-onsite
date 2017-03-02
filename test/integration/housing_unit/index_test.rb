require 'test_helper'

class HousingUnit::IndexTest < IntegrationTest
  before do
    @user = create_login_user
    @housing_facility = create :housing_facility_with_units
  end

  test '#index filters' do
    navigate_to_units_index

    within('.filter_form') do
      assert_text 'Housing facility'
      assert_text 'Stays'
      assert_text 'People'
      assert_text 'Name'
      assert_text 'Created at'
      assert_text 'Updated at'
    end
  end

  test '#index columns' do
    navigate_to_units_index

    assert_index_columns :id, :name, :created_at, :updated_at, :actions
  end

  test '#index items' do
    navigate_to_units_index

    within('#index_table_housing_units') do
      assert_selector "#housing_unit_#{@housing_facility.housing_units.sample.id}"
    end
  end

  private

  def navigate_to_units_index
    visit housing_facility_path(@housing_facility)
    assert_selector 'h2#page_title', text: @housing_facility.name

    click_link "All Units (#{@housing_facility.housing_units.size})"
    assert_selector 'h2#page_title', text: "#{@housing_facility.name}: Units"
  end
end
