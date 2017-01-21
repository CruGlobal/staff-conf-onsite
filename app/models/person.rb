class Person < ApplicationRecord
  # The possible values for the +gender+ attribute.
  GENDERS = { f: 'Female', m: 'Male' }.freeze

  # Whenever we calculate someone's age, it's as-of this date, and not the
  # current calendar date.
  AGE_AS_OF = Date.parse('2017-06-01').freeze

  has_paper_trail

  belongs_to :family
  belongs_to :ministry

  has_many :cost_adjustments
  has_many :meal_exemptions
  has_many :stays

  accepts_nested_attributes_for :stays, :cost_adjustments, allow_destroy: true

  validates :family_id, presence: true
  validates :gender, inclusion: { in: GENDERS.keys.map(&:to_s) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def audit_name
    "#{super}: #{full_name}"
  end

  def age
    @age ||= age_from_birthdate
  end

  private

  def age_from_birthdate
    age = AGE_AS_OF.year - birthdate.year
    age -= 1 if birthday_after_date
    age
  end

  def birthday_after_date
    birthdate.month > AGE_AS_OF.month ||
      birthdate.month == AGE_AS_OF.month && birthdate.day > AGE_AS_OF.day
  end
end
