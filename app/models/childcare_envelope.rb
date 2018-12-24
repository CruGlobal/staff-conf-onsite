class ChildcareEnvelope < ApplicationRecord
  ENVELOPE_STATUSES = ['sent', 'delivered', 'completed', 'declined', 'voided'].freeze
  FAILED_ENVELOPE_STATUSES = ['declined', 'voided'].freeze
  COMPLETED_ENVELOPE_STATUS = 'completed'.freeze
  FINAL_ENVELOPE_STATUSES = (FAILED_ENVELOPE_STATUSES + [COMPLETED_ENVELOPE_STATUS]).freeze

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
