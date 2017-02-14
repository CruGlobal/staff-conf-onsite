class Person < ApplicationRecord
  # The possible values for the +gender+ attribute.
  GENDERS = { f: 'Female', m: 'Male' }.freeze

  # Whenever we calculate someone's age, it's as-of this date, and not the
  # current calendar date.
  AGE_AS_OF = Date.parse('2017-06-01').freeze

  has_paper_trail

  belongs_to :family
  belongs_to :ministry

  has_many :cost_adjustments, dependent: :destroy
  has_many :meal_exemptions, dependent: :destroy
  has_many :stays, dependent: :destroy

  accepts_nested_attributes_for :stays, :cost_adjustments, allow_destroy: true

  validates :family_id, presence: true
  validates :gender, inclusion: { in: GENDERS.keys.map(&:to_s) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def audit_name
    "#{super}: #{full_name}"
  end
end
