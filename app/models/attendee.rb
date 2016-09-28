class Attendee < Person
  # TODO: Housing Preferences

  belongs_to :family

  has_many :conference_attendances
  has_many :conferences, through: :conference_attendances
  has_many :course_attendances
  has_many :courses, through: :course_attendances
  has_many :meals
end
