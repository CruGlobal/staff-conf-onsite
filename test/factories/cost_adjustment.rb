FactoryBot.define do
  factory :cost_adjustment do
    person factory: :attendee

    price_cents do
      if @overrides[:percent].nil? && Faker::Boolean.boolean
        Faker::Number.between(from: 1, to: 1000_00)
      end
    end

    percent do
      Faker::Number.between(from: 0.1, to: 100.0) unless price_cents.present?
    end

    description { Faker::Lorem.paragraph(sentence_count: rand(3)) }
    cost_type { CostAdjustment.cost_types.values.sample }
  end
end
