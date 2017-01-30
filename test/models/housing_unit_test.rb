require 'test_helper'

class HousingUnitTest < ActiveSupport::TestCase
  setup do
    create_users
    @housing_unit = create :housing_unit
  end

  test 'permit create' do
    refute_permit @general_user, @housing_unit, :create
    refute_permit @finance_user, @housing_unit, :create

    assert_permit @admin_user, @housing_unit, :create
  end

  test 'permit read' do
    assert_permit @general_user, @housing_unit, :show
    assert_permit @finance_user, @housing_unit, :show
    assert_permit @admin_user, @housing_unit, :show
  end

  test 'permit update' do
    refute_permit @general_user, @housing_unit, :update
    refute_permit @finance_user, @housing_unit, :update

    assert_permit @admin_user, @housing_unit, :update
  end

  test 'permit destroy' do
    refute_permit @general_user, @housing_unit, :destroy
    refute_permit @finance_user, @housing_unit, :destroy

    assert_permit @admin_user, @housing_unit, :destroy
  end

  test '.hierarchy when no Facilities exist' do
    HousingFacility.all.each(&:destroy!)
    hierarchy = HousingUnit.hierarchy
    assert_empty hierarchy
  end

  test '.hierarchy when one Facilities exists' do
    expected_facility = @housing_unit.housing_facility

    hierarchy = HousingUnit.hierarchy

    assert_equal 1, hierarchy.size
    assert_equal expected_facility.housing_type, hierarchy.keys.first.downcase
    assert_includes hierarchy.first.last[expected_facility], @housing_unit
  end

  test '.hierarchy when two Units share a Facility' do
    expected_facility = @housing_unit.housing_facility
    @other_unit = create :housing_unit, housing_facility: expected_facility

    hierarchy = HousingUnit.hierarchy

    assert_equal 1, hierarchy.size
    assert_equal 2, hierarchy.first.last[expected_facility].size
  end
end
