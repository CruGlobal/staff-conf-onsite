ActiveAdmin.register CourseAttendance, as: 'IBS Course' do
  actions :index
  partial_view :index

  controller do
    def scoped_collection
      end_of_association_chain.includes(:attendee, :course)
    end
  end

  filter :attendee_first_name_or_attendee_last_name_cont, label: 'Student'
  filter :attendee_student_number_cont, label: 'Student Number'
  filter :course_name_cont, label: 'Class'
  filter :grade, as: :select, collection: CourseAttendance.grades
end
