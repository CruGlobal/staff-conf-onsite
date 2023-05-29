FactoryBot.define do
  factory :childcare_envelope do
    envelope_id { SecureRandom.uuid }
    status      { 'sent' }
    child
    association :recipient, factory: :attendee

    after(:build) { |ce| ce.recipient.family = ce.child.family }

    trait :sent do
      status { "sent" }
    end

    trait :delivered do
      status { "delivered" }
    end
    
    trait :completed do
      status { "completed" }
    end
    
    trait :declined do
      status { "declined" }
    end
    
    trait :voided do
      status { "voided" }
    end
  end
end
