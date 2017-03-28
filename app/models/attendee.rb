class Attendee < Person
  include FamilyMember

  after_initialize :set_default_seminary

  belongs_to :family
  belongs_to :seminary

  has_many :conference_attendances, dependent: :destroy
  has_many :conferences, through: :conference_attendances
  has_many :course_attendances, dependent: :destroy
  has_many :courses, through: :course_attendances

  accepts_nested_attributes_for :course_attendances, allow_destroy: true
  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :seminary_id, :family_id, presence: true
  validates_associated :course_attendances, :meal_exemptions

  protected

  def set_default_seminary
    self.seminary ||= Seminary.default
  end
end
