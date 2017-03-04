require 'test_helper'

class StayTest < ModelTestCase
  setup do
    @facility = create :housing_facility, cost_code: nil
    @unit = create :housing_unit, housing_facility: @facility
    @attendee = create :attendee

    @stay = create :stay, person: @attendee, housing_unit: @unit
  end

  test '#housing_type' do
    assert_equal @facility.housing_type, @stay.housing_type
  end

  test '#housing_type is :self_provided when Unit is absent' do
    @stay.housing_unit = nil
    assert_equal :self_provided, @stay.housing_type
  end

  test '#housing_type is :self_provided when Unit\'s Facility is absent' do
    @unit.housing_facility = nil
    assert_equal :self_provided, @stay.housing_type
  end

  test '#duration' do
    @stay.update!(arrived_at: 6.days.ago, departed_at: 3.days.ago)

    assert_equal 3, @stay.duration
    @stay.departed_at = 6.days.ago + 1.hour
    assert_equal 1, @stay.duration
  end

  test '#min_days' do
    @facility.update!(cost_code: create(:cost_code, min_days: 123))
    assert_equal 123, @stay.min_days
  end

  test '#min_days with no cost_code' do
    assert_equal 1, @stay.min_days
  end
end
