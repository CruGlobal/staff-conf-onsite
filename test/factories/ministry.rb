FactoryGirl.define do
  factory :ministry do
    name { "Ministry of #{Faker::Commerce.department}" }
    code { Ministry::CODES.sample }
  end
end
