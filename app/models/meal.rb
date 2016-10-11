class Meal < ApplicationRecord
  TYPES = %w(Breakfast Lunch Dinner).freeze

  belongs_to :attendee

  validates :meal_type, uniqueness: { scope: [:attendee_id, :date], message:
    'may only have one meal type per day' }

  # Creates a Hash table where each key is Date in which there's one or more
  # Meals. Each element is a map of meal_type to Meal object.
  #
  # @example
  #   Tue, 18 Apr 2017 => Breakfast -> #<Meal:...>
  #                       Lunch     -> #<Meal:...>
  #                       Dinner    -> #<Meal:...>
  #   Sun, 21 May 2017 => Dinner    -> #<Meal:...>
  #   Thu, 14 Sep 2017 => Breakfast -> #<Meal:...>
  #                       Dinner    -> #<Meal:...>
  # @return [Hash<Date, Hash<String, Meal>>]
  def self.order_by_date
    Hash.new { |h, v| h[v] = {} }.tap do |dates|
      all.each { |meal| dates[meal.date][meal.meal_type] = meal }
    end
  end
end
