class Course < ApplicationRecord
  # TODO Is "time schedule" a single time or an associated object
  has_many :course_attendances
  has_many :attendees, through: :course_attendances
end
