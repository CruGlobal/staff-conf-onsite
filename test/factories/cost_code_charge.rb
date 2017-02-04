using InternationalPhoneNumber

FactoryGirl.define do
  factory :cost_code_charge do
    max_days { Faker::Number.between(0, 100) }
    infant_cents { Faker::Number.between(5_000, 10_000) }
    child_cents { Faker::Number.between(10_000, 15_000) }
    teen_cents { Faker::Number.between(10_000, 15_000) }
    adult_cents { Faker::Number.between(15_000, 20_00) }
  end
end
