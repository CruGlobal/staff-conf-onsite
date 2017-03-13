class Attendee < Person
  include FamilyMember

  belongs_to :family
  belongs_to :seminary

  has_many :conference_attendances, dependent: :destroy
  has_many :conferences, through: :conference_attendances
  has_many :course_attendances, dependent: :destroy
  has_many :courses, through: :course_attendances

  accepts_nested_attributes_for :course_attendances, allow_destroy: true
  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, presence: true
  validates_associated :course_attendances, :meal_exemptions
end
