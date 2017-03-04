require 'test_helper'

class HousingFacilityTest < ModelTestCase
  setup do
    create_users
    @housing_facility = create :housing_facility, cost_code: nil
  end

  test '#min_days' do
    @housing_facility.update!(cost_code: create(:cost_code, min_days: 123))
    assert_equal 123, @housing_facility.min_days
  end

  test '#min_days with no cost_code' do
    assert_equal 1, @housing_facility.min_days
  end

  test 'permit create' do
    assert_accessible :create, @housing_facility, only: :admin
  end

  test 'permit read' do
    assert_accessible :show, @housing_facility, only: [:admin, :finance, :general]
  end

  test 'permit update' do
    assert_accessible :update, @housing_facility, only: :admin
  end

  test 'permit destroy' do
    assert_accessible :destroy, @housing_facility, only: :admin
  end
end
