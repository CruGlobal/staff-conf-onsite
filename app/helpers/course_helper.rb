module CourseHelper
  I18N_PREFIX_COURSE = 'activerecord.attributes.course'.freeze

  def course_grade_select
    CourseAttendance.grades.keys.map do |grade|
      [course_grade_name(grade), grade]
    end
  end

  def course_grade_name(grade)
    I18n.t("#{I18N_PREFIX_COURSE}.grades.#{grade}", default: grade)
  end

  def seminary_code(attendance)
    if attendance.seminary_credit
      attendance&.seminary&.code
    else
      'IBS'
    end
  end

  def grading_option(attendance)
    attendance.grade == 'AU' ? 'A' : 'G'
  end
end
