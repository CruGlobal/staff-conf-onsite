class Course::ShowCell < ::ShowCell
  property :course

  def show
    columns do
      column { course_attributes_table }
      column { attendees_panel }
    end

    active_admin_comments
  end

  private

  def course_attributes_table
    attributes_table do
      row :name
      row :instructor
      row(:price) { |c| humanized_money_with_symbol(c.price) }
      row(:description) { |c| html_full(c.description) }
      row :week_descriptor
      row :ibs_code
      row :location
      row :created_at
      row :updated_at
    end
  end

  def attendees_panel
    attendances = course.course_attendances.includes(:attendee)
    size = attendances.size

    panel "Attendees (#{size})", class: 'attendees' do
      size.positive? ? attendance_table(attendances) : strong('None')
    end
  end

  def attendance_table(attendances)
    table_for attendances do
      column(:attendee) { |a| link_to(a.attendee.full_name, a.attendee) }
      column :grade
      column :seminary_credit
    end
  end
end
