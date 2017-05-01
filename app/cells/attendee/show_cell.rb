class Attendee::ShowCell < ::ShowCell
  property :attendee

  def show
    columns do
      column { left_column }
      column { right_column }
    end

    if current_user.finance?
      cell('attendee/finances', self, attendee: attendee).call
    end
    active_admin_comments
  end

  private

  def person_cell
    @person_cell ||= cell('person/show', model, person: attendee)
  end

  def left_column
    conference_status_table
    attendee_attributes_table
  end

  def right_column
    conferences_panel
    attendances_panel
    person_cell.call(:stays)
    person_cell.call(:cost_adjustments)
    person_cell.call(:meal_exemptions)
  end

  def conference_status_table
    panel 'Conference Status' do
      div class: 'attributes_table' do
        table do
          conference_status_table_status_row
          conference_status_table_changed_at_row
        end
      end
    end
  end

  def conference_status_table_status_row
    tr do
      th { 'Status' }
      td { attendee.conference_status }
    end
  end

  def conference_status_table_changed_at_row
    tr do
      th { 'Last Changed At' }
      td do
        if attendee.conference_status_changed_at.present?
          format_attribute(attendee, :conference_status_changed_at)
        else
          span('Never', class: :empty)
        end
      end
    end
  end

  def attendee_attributes_table
    attributes_table do
      personal_rows
      contact_rows
      ministry_row
      row :seminary
      row :department
      rec_center_pass_rows
      row :arrived_at
      row :departed_at
      row :created_at
      row :updated_at
    end
  end

  def personal_rows
    row :first_name
    row :last_name
    row :tshirt_size
    row(:family) { |a| link_to family_label(a.family), family_path(a.family) }
    row(:birthdate) { |a| birthdate_label(a) }
    row(:age, sortable: :birthdate) { |a| age_label(a) }
    row(:gender) { |a| gender_name(a.gender) }
    row :mobility_comment
    row :personal_comment
  end

  def contact_rows
    row(:email) { |a| mail_to(a.email) }
    row(:phone) { |a| format_phone(a.phone) }
    row :emergency_contact
  end

  def ministry_row
    row(:ministry) do |a|
      if a.ministry_id.present?
        link_to a.ministry.to_s, ministry_path(a.ministry_id)
      end
    end
  end

  def rec_center_pass_rows
    row :rec_center_pass_started_at
    row :rec_center_pass_expired_at
  end

  def conferences_panel
    panel "Conferences (#{attendee.conferences.size})", class: 'conferences' do
      attendee.conferences.any? ? conference_list : strong('None')
      conference_comment
    end
  end

  def conference_comment
    div class: 'attendance-comment' do
      h4 'Comments'
      if attendee.conference_comment.present?
        para attendee.conference_comment
      else
        para strong 'None'
      end
    end
  end

  def conference_list
    ul do
      attendee.conferences.each { |c| li { link_to(c.name, c) } }
    end
  end

  def attendances_panel
    panel 'Courses', class: 'attendances' do
      student_number

      attendances = attendee.course_attendances.includes(:course)
      attendances.any? ? attendances_list(attendances) : strong('No Courses')

      course_comment
    end
  end

  def student_number
    div do
      strong 'Student Number: '
      code attendee.student_number
      hr
    end
  end

  def attendances_list(attendances)
    table_for attendances.sort_by { |a| a.course.name } do
      column :course
      column :grade
      column :seminary_credit
    end
  end

  def course_comment
    div class: 'attendance-comment' do
      h4 'IBS Comments'
      if attendee.ibs_comment.present?
        para attendee.ibs_comment
      else
        para strong 'None'
      end
    end
  end
end
