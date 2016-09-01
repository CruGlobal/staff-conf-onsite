FactoryGirl.define do
  factory :room do
    housing_facility
    sequence(:number) { |n| 100 + n }
  end
end
