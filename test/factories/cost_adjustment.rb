FactoryGirl.define do
  factory :cost_adjustment do
    person factory: :attendee

    price_cents do
      Faker::Number.between(0, 1000_00) if Faker::Boolean.boolean
    end
    percent do
      Faker::Number.between(0, 100.0) unless price_cents.present?
    end

    description { Faker::Lorem.paragraph(rand(3)) }
    cost_type { CostAdjustment.cost_types.values.sample }
  end
end
