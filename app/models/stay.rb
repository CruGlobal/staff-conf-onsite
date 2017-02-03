class Stay < ActiveRecord::Base
  HOUSING_TYPE_FIELDS = {
    single_occupancy: [:dormitory].freeze,
    no_charge: [:apartment].freeze,
    waive_minimum: [:apartment].freeze,
    percentage: [:apartment].freeze
  }.freeze

  validates :person_id, :arrived_at, :departed_at, presence: true
  validates :percentage, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  belongs_to :person
  belongs_to :housing_unit

  def housing_type
    type = housing_unit.try(:housing_facility).try(:housing_type)
    type || :self_provided
  end

  def length_of_stay
    [(departed_at - arrived_at).to_i, 1].max
  end

  def cost_of_stay
    case person.age
    when 0..4
      cost_for_person_of_age_group('infant')
    when 5..10
      cost_for_person_of_age_group('child')
    when 11..14
      cost_for_person_of_age_group('teen')
    else
      cost_for_person_of_age_group('adult')
    end
  end

  private

  def calculate_cost_related_to_charge_field(beginning_of_field_name)
    total_charges_in_cents = 0
    number_of_days_charged = 0

    until length_of_stay == number_of_days_charged
      charge = charge_with_smallest_max_days_over_n(number_of_days_charged)
      days_charged_in_this_cycle = [charge.max_days, length_of_stay - number_of_days_charged].min
      total_charges_in_cents += charge.send("#{beginning_of_field_name}_cents") * days_charged_in_this_cycle
      number_of_days_charged += days_charged_in_this_cycle
    end
    total_charges_in_cents.to_f / 100
  end

  def charge_with_smallest_max_days_over_n(number_of_days)
    housing_facility.cost_code.charges.where('max_days > ?', number_of_days).order('max_days asc').first
  rescue NoMethodError
    raise NotImplementedError,
          "Housing Facility with id #{housing_unit.housing_facility.id} is missing a cost_code. It must be added."
  end

  def child_to_be_charged_meal_only?
    person.age < 11 && !person.needs_bed?
  end

  def cost_for_person_of_age_group(age_group)
    return calculate_cost_related_to_charge_field('child_meal') if child_to_be_charged_meal_only?

    cost = calculate_cost_related_to_charge_field(age_group)
    cost += calculate_cost_related_to_charge_field('single_delta') if person_to_be_charged_single_occupancy_fee?
    cost
  end

  def housing_facility
    housing_unit.housing_facility
  end

  def person_to_be_charged_single_occupancy_fee?
    person.age > 14 && single_occupancy?
  end
end
