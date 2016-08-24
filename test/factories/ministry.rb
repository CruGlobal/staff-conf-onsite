FactoryGirl.define do
  factory :ministry do
    name { "Ministry of #{Faker::Commerce.department}" }
    description { Faker::Lorem.paragraph(rand(3)) }
  end
end
