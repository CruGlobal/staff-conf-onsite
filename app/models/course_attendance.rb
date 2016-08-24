class CourseAttendance < ApplicationRecord
  belongs_to :course
  belongs_to :attendee

  validates :attendee_id, uniqueness: { scope: :course_id,
    message: 'may only sign up for a class once' }
end
