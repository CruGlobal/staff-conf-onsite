FactoryGirl.define do
  factory :housing_unit do
    housing_facility
    sequence(:name) { |n| format("%s%03d", (?A..?Z).to_a.sample, n) }
  end
end
