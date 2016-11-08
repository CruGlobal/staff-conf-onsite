FactoryGirl.define do
  factory :ministry do
    name { "Ministry of #{Faker::Commerce.department}" }
  end
end
