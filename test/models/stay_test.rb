require 'test_helper'

class StayTest < ActiveSupport::TestCase
  setup do
    @person = create(:child, birthdate: 9.years.ago)
    @housing_facility = create(:housing_facility)
    @housing_unit = create(:housing_unit, housing_facility: @housing_facility)
    @stay = create(:stay, arrived_at: 6.days.ago, departed_at: 3.days.ago,
                          person: @person, housing_unit: @housing_unit)
    @cost_code = create(:cost_code, housing_facilities: [@housing_facility])
    @cost_code_charges = []
    [2,5,9999].each do |max_days|
      @cost_code_charges << create(:cost_code_charge, :max_days => max_days,
                                                      :cost_code => @cost_code)
    end
  end

  test '#length_of_stay' do
    assert_equal 3, @stay.length_of_stay
    @stay.departed_at = 6.days.ago + 1.hour
    assert_equal 1, @stay.length_of_stay
  end

  test '#cost_of_stay' do
    assert_equal 3, @stay.cost_of_stay
  end

  private

  def cost_of_stay(age_group)
    age_group.length * 5000
  end
end
