FactoryBot.define do
  factory :chargeable_staff_number do
    staff_number { Faker::Number.number(digits: 10) }
  end
end
