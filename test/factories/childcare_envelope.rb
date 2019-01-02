FactoryGirl.define do
  factory :childcare_envelope do
    envelope_id { SecureRandom.uuid }
    status      { ['sent', 'delivered', 'completed', 'declined', 'voided'].sample }
    child
    association :recipient, factory: :attendee

    after(:build) { |ce| ce.recipient.family = ce.child.family }
  end
end
