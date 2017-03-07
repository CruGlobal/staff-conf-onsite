class Person < ApplicationRecord
  # The possible values for the +gender+ attribute.
  GENDERS = { f: 'Female', m: 'Male' }.freeze

  has_paper_trail

  belongs_to :family
  belongs_to :ministry

  has_many :cost_adjustments, dependent: :destroy
  has_many :meal_exemptions, dependent: :destroy
  has_many :stays, dependent: :destroy
  has_many :housing_units, through: :stays

  accepts_nested_attributes_for :stays, :cost_adjustments, allow_destroy: true

  validates :family_id, presence: true
  validates :gender, inclusion: { in: GENDERS.keys.map(&:to_s) }
  validates_associated :stays

  def full_name
    "#{first_name} #{last_name}"
  end

  def audit_name
    "#{super}: #{full_name}"
  end

  def age
    @age ||= age_from_birthdate
  end

  def birthdate=(*_)
    @age = nil
    super
  end

  private

  def age_from_birthdate
    cutoff = UserVariable[:child_age_cutoff]

    age = cutoff.year - birthdate.year
    age -= 1 if birthday_after_date?
    age
  end

  def birthday_after_date?
    cutoff = UserVariable[:child_age_cutoff]

    birthdate.month > cutoff.month ||
      birthdate.month == cutoff.month && birthdate.day > cutoff.day
  end
end
