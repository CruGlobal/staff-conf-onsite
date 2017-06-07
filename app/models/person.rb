class Person < ApplicationRecord
  # The possible values for the +gender+ attribute.
  GENDERS = { f: 'Female', m: 'Male' }.freeze

  FORM_OPTIONS ||= {
    # If creating a new family-member, show the family name in the title
    title: proc do |person|
      label = "#{action_name.titlecase} #{person.class.name}"

      if (family = person.family || param_family)
        "#{label} (#{family_label(family)})"
      else
        label
      end
    end
  }.freeze

  has_paper_trail

  belongs_to :family
  belongs_to :ministry

  has_many :cost_adjustments, dependent: :destroy
  has_many :meal_exemptions, dependent: :destroy
  has_many :stays, dependent: :destroy
  has_many :housing_units, through: :stays

  accepts_nested_attributes_for :stays, :cost_adjustments, allow_destroy: true

  after_create :ensure_primary_person

  validates :rec_center_pass_started_at, presence: true, if: :rec_center_pass_expired_at?
  validates :rec_center_pass_expired_at, presence: true, if: :rec_center_pass_started_at?

  validates :family_id, presence: true
  validates :gender, inclusion: { in: GENDERS.keys.map(&:to_s) }
  validates_associated :stays

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def audit_name
    "#{super}: #{full_name}"
  end

  def full_name_tag
    first = name_tag_first_name.present? ? name_tag_first_name : first_name
    last  = name_tag_last_name.present?  ? name_tag_last_name  : last_name

    [first, last].compact.join(' ')
  end

  def age
    @age ||= age_from_birthdate
  end

  def birthdate=(*_)
    @age = nil
    super
  end

  # @return [Boolean] if this person is staying in an
  #   {HousingFacility#on_campus on-campus facility} on the given date
  def on_campus_at?(date)
    stays.for_date(date).any?(&:on_campus?)
  end

  private

  def age_from_birthdate
    return 0 unless birthdate.present?
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

  def ensure_primary_person
    unless family.primary_person_id.present?
      family.update!(primary_person_id: id)
    end
  end
end
