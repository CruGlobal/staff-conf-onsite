class ChildcareEnvelope < ApplicationRecord
  ENVELOPE_STATUSES = %w[sent delivered completed declined voided].freeze
  FAILED_ENVELOPE_STATUSES = %w[declined voided].freeze
  COMPLETED_ENVELOPE_STATUS = 'completed'.freeze
  IN_PROCESS_ENVELOPE_STATUSES = %w[sent delivered].freeze

  belongs_to :child
  belongs_to :recipient, class_name: 'Attendee'

  validates :envelope_id, :status, presence: true
  validates :status, inclusion: { in: ENVELOPE_STATUSES }
  validate :must_belong_to_same_family

  before_validation :normalize_status

  def must_belong_to_same_family
    if child.family_id != recipient.family_id
      errors.add(:child, 'is not part of the recipients family')
    end
  end

  private

  def normalize_status
    self.status = status&.strip&.downcase
  end
end
