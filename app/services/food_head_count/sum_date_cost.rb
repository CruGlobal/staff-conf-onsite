class FoodHeadCount::SumDateCost < ApplicationService
  DEFAULT_NAME = 'N/A'.freeze

  # The date to create the head count for
  attr_accessor :date

  # An optional cafeteria by which to filter the count
  attr_accessor :cafeteria

  def call
    stays = stay_scope.for_date(date)
    stays.each(&method(:count_meals_for_stay))
  end

  def counts
    @counts ||= Hash.new do |hash, cafe|
      hash[cafe] = {
        adult_breakfast: 0,
        adult_lunch:     0,
        adult_dinner:    0,

        teen_breakfast:  0,
        teen_lunch:      0,
        teen_dinner:     0,

        child_breakfast: 0,
        child_lunch:     0,
        child_dinner:    0
      }
    end
  end

  private

  def stay_scope
    @stays ||= Stay.in_dormitory.includes(person: :meal_exemptions,
                                          housing_unit: :housing_facility)
  end

  def count_meals_for_stay(stay)
    type = person_type(stay.person)
    return unless type.present?

    cafe = stay.housing_facility.cafeteria
    return if skip?(cafe)

    applicable_meals(stay).each do |meal|
      counts[cafe || DEFAULT_NAME][format('%s_%s', type, meal).to_sym] += 1
    end
  end

  def person_type(person)
    age = person.age

    if person.is_a?(Attendee)
      :adult
    elsif age >= 15
      :adult
    elsif age >= 11
      :teen
    elsif age >= 5
      :child
    end
  end

  def skip?(cafe)
    cafeteria.present? && cafe != cafeteria
  end

  def applicable_meals(stay)
    (MealExemption::TYPES - exempt_meals(stay.person)).map(&:downcase)
  end

  def exempt_meals(person)
    person.meal_exemptions.select { |me| me.date == date }.map(&:meal_type)
  end
end
