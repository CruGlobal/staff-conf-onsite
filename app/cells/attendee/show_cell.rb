class Attendee::ShowCell < ::ShowCell
  property :attendee

  def show
    columns do
      column { left_column }
      column { right_column }
    end

    active_admin_comments
  end

  private

  def person_cell
    @person_cell ||= cell('person/show', model, person: attendee)
  end

  def left_column
    attendee_attributes_table
    conferences_panel
    attendances_panel
  end

  def right_column
    person_cell.call(:stays)
    person_cell.call(:cost_adjustments)
    temporary_stay_cost_panel
    person_cell.call(:meal_exemptions)
  end

  def attendee_attributes_table
    attributes_table do
      row :id
      row(:student_number) { |a| code a.student_number }
      personal_rows
      contact_rows
      ministry_row
      row :department
      row :arrived_at
      row :departed_at
      row :created_at
      row :updated_at
    end
  end

  def personal_rows
    row :first_name
    row :last_name
    row(:family) { |a| link_to family_label(a.family), family_path(a.family) }
    row :birthdate
    row(:age, sortable: :birthdate) { |a| age_label(a) }
    row(:gender) { |a| gender_name(a.gender) }
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

  def conferences_panel
    panel "Conferences (#{attendee.conferences.size})", class: 'conferences' do
      attendee.conferences.any? ? conference_list : strong('None')
    end
  end

  def conference_list
    ul do
      attendee.conferences.each { |c| li { link_to(c.name, c) } }
    end
  end

  def attendances_panel
    panel 'Courses', class: 'attendances' do
      attendances = attendee.course_attendances.includes(:course)
      attendances.any? ? attendances_list(attendances) : strong('None')
    end
  end

  def attendances_list(attendances)
    table_for attendances.sort_by { |a| a.course.name } do
      column :course
      column :grade
      column :seminary_credit
    end
  end

  # TODO: This is for client-demo purposes. This will be part of some report in
  #       the future.
  def temporary_stay_cost_panel
    panel 'Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = ChargeAttendeeStays.call(attendee: attendee)
      if result.success?
        temporary_stay_individual_dorms_cost_list
        temporary_stay_cost_table(result)
      else
        div(class: 'flash flash_error') { result.error }
      end
    end
  end

  def temporary_stay_individual_dorms_cost_list
    stays = attendee.stays
    return if stays.empty?

    h4 'Individual Stays:'
    dl do
      stays.each do |stay|
        dt { join_stay_dates(stay) }
        dd { temporary_stay_individual_dorms_cost_list_item(stay) }
      end
    end
  end

  def temporary_stay_individual_dorms_cost_list_item(stay)
    result = SingleAttendeeStayCost.call(stay: stay)
    if result.success?
      text_node humanized_money_with_symbol result.total
    else
      div(class: 'flash flash_error') { result.error }
    end
  end

  def temporary_stay_cost_table(result)
    table do
      temporary_stay_cost_table_head
      tr do
        td { humanized_money_with_symbol result.subtotal }
        td { humanized_money_with_symbol result.total_adjustments * -1 }
        td { humanized_money_with_symbol result.total }
      end
    end
  end

  def temporary_stay_cost_table_head
    tr do
      th { 'Sub-Total' }
      th { 'Adjustments' }
      th { 'Total' }
    end
  end
end
