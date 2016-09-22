FactoryGirl.define do
  factory :cost_adjustment do
    person factory: :attendee
    cents { Faker::Number.between(0, 1000_00) }
    description { Faker::Lorem.paragraph(rand(3)) }
  end
end
