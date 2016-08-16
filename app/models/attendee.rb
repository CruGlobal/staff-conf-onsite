class Attendee < Person
  # TODO Comments
  # TODO Housing Preferences
  # TODO Cost Adjustments

  belongs_to :family
  has_many :course_attendances
  has_many :courses, through: :course_attendances
end
