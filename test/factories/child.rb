FactoryGirl.define do
  factory :child do
    family

    first_name { Faker::Name.first_name }
    last_name { Faker::Boolean.boolean(0.9) ? nil : Faker::Name.last_name }
    birthdate { Faker::Date.between(12.years.ago, 1.years.ago) }
    gender { Person::GENDERS.keys.sample }
  end
end
