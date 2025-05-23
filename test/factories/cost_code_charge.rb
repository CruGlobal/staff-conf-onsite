FactoryBot.define do
  factory :cost_code_charge do
    cost_code
    max_days { Faker::Number.between(from: 1, to: 100) }

    adult_cents        { Faker::Number.between(from: 1, to: 100_00) }
    teen_cents         { Faker::Number.between(from: 1, to: 100_00) }
    child_cents        { Faker::Number.between(from: 1, to: 100_00) }
    infant_cents       { Faker::Number.between(from: 1, to: 100_00) }
    child_meal_cents   { Faker::Number.between(from: 1, to: 100_00) }
    single_delta_cents { Faker::Number.between(from: 1, to: 100_00) }
  end
end
