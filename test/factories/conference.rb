FactoryBot.define do
  factory :conference do
    name { Faker::Educator.course_name }
    description { Faker::Lorem.paragraph(sentence_count: rand(3)) }
    price_cents { Faker::Number.between(from: 0, to: 1000_00) }
    start_at { Faker::Date.between(from: 1.year.ago, to: 1.year.from_now) }
    end_at { Faker::Date.between(from: start_at + 1.day, to: 1.year.from_now + 1.day) }
  end
end
