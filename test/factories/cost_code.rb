FactoryBot.define do
  factory :cost_code do
    name { Faker::Code.asin }
    description { Faker::Lorem.paragraph(sentence_count: rand(3)) }
    min_days { Faker::Number.between(from: 1, to: 100) }

    factory :cost_code_with_charges do
      transient do
        count { 5 }
      end

      after(:create) do |cost_code, params|
        create_list(:cost_code_charge, params.count, cost_code: cost_code)
      end
    end

    factory :cost_code_with_long_max_days do
      transient do
        max_days { 10_000 }
      end

      after(:create) do |cost_code, params|
        create_list(:cost_code_charge, 1, cost_code: cost_code,
                                          max_days: params.max_days)
      end
    end
  end
end
