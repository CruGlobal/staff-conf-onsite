class Attendee < Person
  include FamilyMember

  CONFERENCE_STATUS_CHECKED_IN = 'Checked-In'.freeze
  CONFERENCE_STATUS_EXEMPT = 'Exempt'.freeze
  CONFERENCE_STATUS_EXPECTED = 'Expected'.freeze
  CONFERENCE_STATUS_ACCEPTED = [
    CONFERENCE_STATUS_EXEMPT,
    CONFERENCE_STATUS_CHECKED_IN,
    'Staff Conf Not Required'
  ].freeze

  CONFERENCE_STATUSES =
    (%w[Registered] + [CONFERENCE_STATUS_EXPECTED] + CONFERENCE_STATUS_ACCEPTED).freeze

  after_initialize :set_default_seminary
  before_save :touch_conference_status_changed, if: :conference_status_changed?
  
  # Move callbacks to after_commit to prevent nested transactions
  after_commit :update_family_spouses, on: [:create, :update, :destroy]

  belongs_to :family, optional: true
  belongs_to :seminary, optional: true
  belongs_to :spouse, class_name: 'Attendee', optional: true

  has_many :conference_attendances, dependent: :destroy
  has_many :conferences, through: :conference_attendances
  has_many :course_attendances, dependent: :destroy
  has_many :courses, through: :course_attendances
  has_many :childcare_envelopes, dependent: :nullify, foreign_key: 'recipient_id', inverse_of: :recipient

  accepts_nested_attributes_for :course_attendances, allow_destroy: true
  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, :seminary_id, presence: true
  validates :conference_status, presence: true
  validates_associated :course_attendances, :meal_exemptions

  def conference_names
    conferences.pluck(:name).join(', ')
  end

  def check_in!
    unless checked_in?
      self.conference_status = CONFERENCE_STATUS_CHECKED_IN
      save(validate: false)
    end
  end

  def checked_in?
    CONFERENCE_STATUS_ACCEPTED.include?(conference_status)
  end

  def no_dates?
    arrived_at.blank? && departed_at.blank? && stays.empty?
  end

  def exempt?
    conference_status == 'Exempt'
  end

  def main_ministry
    return nil unless ministry

    ministry.ancestors[1] || ministry
  end

  def cohort
    return nil unless campus_ministry_member?

    ministry.ancestors[2]
  end

  def campus_ministry_member?
    return false unless ministry

    ministry.ancestors.map(&:code).include?('CM')
  end

  protected

  def set_default_seminary
    self.seminary_id ||= Seminary.default&.id
  end

  def touch_conference_status_changed
    self.conference_status_changed_at = Time.zone.now
  end

  private

  def update_family_spouses
    return if destroyed? # Prevent running on destroyed records
    
    # Update current family
    family&.update_spouses
    
    # Update previous family if family_id changed
    if saved_change_to_family_id? && family_id_before_last_save
      Family.find_by(id: family_id_before_last_save)&.update_spouses
    end
  end
end
