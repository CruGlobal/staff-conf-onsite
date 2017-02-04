require 'test_helper'

class StayTest < ActiveSupport::TestCase
  setup do
    @child = create(:child, birthdate: 4.years.ago)
    @adult = create(:attendee)
    @child_stay = create_stay_for_person(@child)
    @attendee_stay = create_stay_for_person(@adult)
    create_cost_code_and_charges
  end

  test '#length_of_stay' do
    assert_equal 3, @child_stay.length_of_stay
    @child_stay.departed_at = 6.days.ago + 1.hour
    assert_equal 1, @child_stay.length_of_stay
  end

  test '#cost_of_stay' do
    assert_equal 160.00, @child_stay.cost_of_stay
    @child.update(birthdate: 9.years.ago)
    assert_equal 200.00, @child_stay.cost_of_stay
    @child.update(needs_bed: false)
    assert_equal 54.00, @child_stay.cost_of_stay
    @child.update(birthdate: 13.years.ago)
    assert_equal 240.00, @child_stay.cost_of_stay
    assert_equal 280.00, @attendee_stay.cost_of_stay
    @attendee_stay.update(single_occupancy: true)
    assert_equal 360.00, @attendee_stay.cost_of_stay
  end

  test '#cost_of_stay must raise understandable error when cost_code is missing from housing_facility' do
    assert_raise NotImplementedError do
      @housing_facility.update(cost_code: nil)
      @child_stay.cost_of_stay
    end
  end

  private

  def cost_of_stay(age_group)
    age_group.length * 5000
  end

  def create_charge_from_max_days_and_index(max_days, index)
    create(
      :cost_code_charge, max_days:           max_days,
                         infant_cents:       (index + 1) * 4000,
                         child_cents:        (index + 1) * 5000,
                         teen_cents:         (index + 1) * 6000,
                         adult_cents:        (index + 1) * 7000,
                         child_meal_cents:   1800,
                         single_delta_cents: (index + 1) * 2000,
                         cost_code:          @cost_code
    )
  end

  def create_cost_code_and_charges
    @cost_code = create(:cost_code, housing_facilities: [@housing_facility])
    @cost_code_charges = []
    [2,5,9999].each_with_index do |max_days, index|
      @cost_code_charges << create_charge_from_max_days_and_index(max_days, index)
    end
  end

  def create_stay_for_person(person)
    @housing_facility ||= create(:housing_facility)
    @housing_unit ||= create(:housing_unit, housing_facility: @housing_facility)
    create(:stay, arrived_at: 6.days.ago, departed_at: 3.days.ago,
                  person: person, housing_unit: @housing_unit)
  end
end
