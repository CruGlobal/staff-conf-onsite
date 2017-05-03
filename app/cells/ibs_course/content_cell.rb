module IbsCourse
  class ContentCell < ::ShowCell
    def show
      h1 'IBS Courses'

      index do
        selectable_column
      end
    end

    private

    def attendances
      CourseAttendance.all
    end
  end
end
