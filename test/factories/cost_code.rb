using InternationalPhoneNumber

FactoryGirl.define do
  factory :cost_code do
    association :housing_facilities

    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
  end
end
