# Defines the form for creating and editong {Attendee} records.
class Attendee::FormCell < ::FormCell
  property :attendee

  def show
    show_errors_if_any

    columns do
      column { attributes_column }
      column { middle_column }
      column { right_column }
    end

    actions
  end

  private

  def middle_column
    course_attendances_subform
    person_cell.call(:stay_subform)
  end

  def right_column
    person_cell.call(:cost_adjustment_subform)
    cell('person/form_meal_exemptions', model, person: attendee).call
  end

  def person_cell
    @person_cell ||= cell('person/form', model, person: attendee)
  end

  def attributes_column
    attendee_inputs
    duration_inputs
    contact_inputs
    ministry_inputs
  end

  def attendee_inputs
    inputs 'Basic', class: 'basic' do
      person_cell.call(:family_selector_or_hidden)

      input :student_number
      input :first_name

      if param_family
        input :last_name, input_html: { value: param_family.last_name }
      else
        input :last_name
      end

      input :gender, as: :select, collection: gender_select
      datepicker_input(model, :birthdate)
    end
  end

  def duration_inputs
    inputs 'Requested Arrival/Departure' do
      datepicker_input(model, :arrived_at)
      datepicker_input(model, :departed_at)
    end
  end

  def contact_inputs
    inputs 'Contact' do
      input :email
      input :phone
      input :emergency_contact
    end
  end

  def ministry_inputs
    inputs do
      select_ministry_widget(model)
      input :department
      input :conferences
    end
  end

  def course_attendances_subform
    collection = [:course_attendances, object.course_attendances]

    panel 'Attendances' do
      has_many :course_attendances, heading: nil, collection:
          collection, new_record: 'Add New Attendance' do |f|
        f.input :course
        f.input :grade, collection: course_grade_select
        f.input :seminary_credit
        f.input :_destroy, as: :boolean, wrapper_html: { class: 'destroy' }
      end
    end
  end
end
