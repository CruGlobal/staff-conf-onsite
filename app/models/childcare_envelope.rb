class ChildcareEnvelope < ApplicationRecord
  belongs_to :child
  belongs_to :recipient, class_name: 'Attendee'

  validates :envelope_id, :status, presence: true
  validate :must_belong_to_same_family

  def must_belong_to_same_family
    if child.family_id != recipient.family_id
      errors.add(:child, "is not part of the recipients family")
    end
  end
end
