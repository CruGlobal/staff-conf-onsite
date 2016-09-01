class Meal < ApplicationRecord
  TYPES = %w(Breakfast Lunch Dinner).freeze

  belongs_to :attendee

  validates :meal_type, uniqueness: { scope: [:attendee_id, :date], message:
    'may only have one meal type per day' }
end
