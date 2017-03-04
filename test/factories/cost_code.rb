FactoryGirl.define do
  factory :cost_code do
    name { Faker::Code.asin }
    description { Faker::Lorem.paragraph(rand(3)) }
    min_days { Faker::Number.between(1, 100) }

    factory :cost_code_with_charges do
      transient do
        count 5
      end

      after(:create) do |cost_code, params|
        create_list(:cost_code_charge, params.count, cost_code: cost_code)
      end
    end
  end
end
