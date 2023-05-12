FactoryBot.define do
  factory :meal_exemption do
    person { build(Faker::Boolean.boolean ? :attendee : :child) }
    date { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    meal_type { MealExemption::TYPES.sample }
  end
end
