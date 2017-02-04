using InternationalPhoneNumber

FactoryGirl.define do
  factory :stay do
    association :housing_unit
    association :person

    arrived_at { Faker::Date.between(100.days.ago, 50.years.ago) }
    departed_at { Faker::Date.between(50.years.ago, 5.years.ago) }
  end
end
