FactoryGirl.define do
  factory :course do
    name { Faker::Educator.course }
    start_at { Faker::Date.between(1.year.ago, 1.year.from_now) }
    end_at { Faker::Date.between(start_at + 1.day, 1.year.from_now + 1.day) }
  end
end
