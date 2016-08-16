class Meal < ApplicationRecord
  belongs_to :person
  # TODO is `meal_type` an enum or free text?
end
