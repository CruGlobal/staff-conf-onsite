using InternationalPhoneNumber

FactoryGirl.define do
  factory :attendee do
    family
    ministry

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    emergency_contact { [true, false].sample }
    phone { Faker::PhoneNumber.international }
    birthdate { Faker::Date.between(75.years.ago, 18.years.ago) }
    student_number { Faker::Number.number(10) }
    staff_number { Faker::Number.number(10) }
    gender { Person::GENDERS.keys.sample }

    factory :attendee_with_meals do
      transient do
        count 20
      end

      after(:create) do |attendee, params|
        create_list(:meal, params.count, attendee: attendee)
      end
    end
  end
end
