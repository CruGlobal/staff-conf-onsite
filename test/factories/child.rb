FactoryGirl.define do
  factory :child do
    family

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate do
      if Faker::Boolean.boolean(0.9)
        Faker::Date.between(12.years.ago, 1.years.ago)
      end
    end
    gender { Person::GENDERS.keys.sample }

    factory :child_with_meal_exemptions do
      transient do
        count 20
      end

      after(:create) do |child, params|
        create_list(:meal_exemption, params.count, person: child)
      end
    end
  end
end
