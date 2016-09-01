FactoryGirl.define do
  factory :meal do
    attendee
    date { Faker::Date.between(1.year.ago, 1.year.from_now) }
    meal_type { Meal::TYPES.sample }
  end
end
