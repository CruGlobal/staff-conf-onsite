FactoryGirl.define do
  factory :ministry do
    name { "Ministry of #{Faker::Commerce.department}" }
    code do
      existing = Ministry.all.pluck(:code)

      c = nil
      while !c || existing.include?(c)
        count = Faker::Number.between(1, 6)
        c = count.times.map { (?A..?Z).to_a.sample }.join
      end
      c
    end
    parent_id { Ministry.all.pluck(:id).sample if Faker::Boolean.boolean(0.9) }
  end
end
