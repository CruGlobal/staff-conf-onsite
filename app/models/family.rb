class Family < ApplicationRecord
  include PersonHelper

  has_paper_trail

  REQUIRED_ACTION_TEAMS = %w[Housing Childcare Finance Info].freeze

  enum precheck_status: %i[
    pending_approval
    changes_requested
    approved
  ]

  has_many :people, dependent: :destroy
  has_many :attendees, dependent: :destroy
  has_many :children, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :childcare_envelopes, through: :children  

  has_one :precheck_email_token, dependent: :destroy
  has_one :hotel_stay, dependent: :destroy
  has_one :housing_preference, autosave: true, dependent: :destroy,
                               inverse_of: :family

  has_one :chargeable_staff_number, primary_key: :staff_number,
                                foreign_key: :staff_number

  belongs_to :primary_person, class_name: 'Attendee', foreign_key: :primary_person_id, optional: true

  accepts_nested_attributes_for :housing_preference
  accepts_nested_attributes_for :people

  validates :last_name, presence: true
  validates_associated :housing_preference

  before_validation :remove_blank_housing_preference
  before_save :touch_precheck_status_changed, if: :precheck_status_changed?

  # Move after_create callbacks to after_commit to prevent nested transactions
  after_commit :create_precheck_email_token!, on: :create
  after_commit :update_spouses, on: [:create, :update]

  scope :precheck_pending_approval,  -> { where(precheck_status: Family.precheck_statuses[:pending_approval]) }
  scope :precheck_changes_requested, -> { where(precheck_status: Family.precheck_statuses[:changes_requested]) }
  scope :precheck_approved,          -> { where(precheck_status: Family.precheck_statuses[:approved]) }

  # @see PersonHelper.family_label
  def to_s
    family_label(self)
  end

  def first_name
    (primary_person || attendees.first).try(:first_name)
  end

  def email
    (primary_person || attendees.first).try(:email)
  end

  def phone
    (primary_person || attendees.first).try(:phone)
  end

  def audit_name
    "#{super}: #{family_label(self)}"
  end

  def chargeable_staff_number?
    chargeable_staff_number.present?
  end

  def cost_adjustments
    people.flat_map(&:cost_adjustments)
  end

  def check_in!
    self.class.transaction { attendees.each(&:check_in!) }

    FamilyMailer.summary(self).deliver_now if anyone_has_email?
  end

  def checked_in?
    attendees.any? && attendees.all?(&:checked_in?)
  end

  def everyone_has_birthdates?
    people.all? { |p| p.birthdate.present? }
  end

  def anyone_has_email?
    attendees.any? { |p| p.email.present? }
  end
 
  def anyone_registered_for_legacy_conferences?
    attendees.find{|a| a.conferences.find{ |c| c.name == 'Legacy'}} != nil
  end

  def update_spouses
    return if destroyed? # Prevent running on destroyed records
    people = attendees.reload.to_a  
    if people.size == 2
      # Use update_all to prevent callbacks
      Attendee.where(id: people.first.id).update_all(spouse_id: people.second.id)
      Attendee.where(id: people.second.id).update_all(spouse_id: people.first.id)
    else
      Attendee.where(id: people.map(&:id)).update_all(spouse_id: nil)
    end
  end

  def required_team_action=(value)
    super Array(value).reject(&:blank?)
  end

  def toggle_required_team_action(team)
    return unless team && REQUIRED_ACTION_TEAMS.include?(team)

    if required_team_action.include?(team)
      update(required_team_action: (required_team_action - [team]))
    else
      update(required_team_action: (required_team_action + [team]))
    end
  end

  private

  def remove_blank_housing_preference
    self.housing_preference = nil if housing_preference&.housing_type&.blank?
  end

  def touch_precheck_status_changed
    self.precheck_status_changed_at = Time.zone.now
  end
end
