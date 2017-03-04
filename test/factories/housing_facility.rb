FactoryGirl.define do
  factory :housing_facility do
    cost_code

    housing_type do
      HousingFacility.housing_types.
        keys.
        reject { |type| type == 'self_provided' }.
        sample
    end
    name { Faker::University.name }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip }
    country_code { Faker::Address.country_code }

    factory :housing_facility_with_units do
      transient do
        count 20
      end

      after(:create) do |hf, params|
        create_list(:housing_unit, params.count, housing_facility: hf)
      end
    end
  end
end
