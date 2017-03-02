FactoryGirl.define do
  factory :child do
    family

    first_name { Faker::Name.first_name }
    last_name { Faker::Boolean.boolean(0.9) ? nil : Faker::Name.last_name }
    birthdate do
      if Faker::Boolean.boolean(0.9)
        Faker::Date.between(12.years.ago, 1.years.ago)
      end
    end
    gender { Person::GENDERS.keys.sample }

    arrived_at do
      if Faker::Boolean.boolean
        Faker::Date.between(1.year.from_now, 2.years.from_now)
      end
    end

    departed_at do
      if Faker::Boolean.boolean
        Faker::Date.between(1.year.from_now, 2.years.from_now)
      end
    end

    # A random number of random weeks
    childcare_weeks do
      if grade_level == 'postHighSchool'
        nil
      else
        count = Childcare::CHILDCARE_WEEKS.size
        samples = Faker::Number.between(0, count)
        (0...count).to_a.shuffle[0...samples]
      end
    end

    grade_level { Child::GRADE_LEVELS.sample }

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
