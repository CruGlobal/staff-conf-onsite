using InternationalPhoneNumber

FactoryGirl.define do
  factory :spouse do
    family

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    emergency_contact { [true, false].sample }
    phone { Faker::PhoneNumber.international }
    birthdate { Faker::Date.between(75.years.ago, 18.years.ago) }
    gender { Person::GENDERS.keys.sample }
  end
end
