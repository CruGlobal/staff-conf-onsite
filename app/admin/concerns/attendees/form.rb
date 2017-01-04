module Attendees
  # Defines the form for creating and editong {Attendee} records.
  module Form
    include People::Form

    def self.included(base)
      base.send :form, FORM_OPTIONS do |f|
        f.semantic_errors

        columns do
          column do
            instance_exec(f, &ATTENDEE_INPUTS)
          end

          column do
            instance_exec(f, attendee, &STAY_SUBFORM)
            instance_exec(f, attendee, &MEAL_EXEMPTIONS_SUBFORM)
          end
        end

        f.actions
      end
    end

    ATTENDEE_INPUTS ||= proc do |f|
      f.inputs 'Basic' do
        instance_exec(f, &FAMILY_SELECTOR)

        f.input :student_number
        f.input :first_name

        if param_family
          f.input :last_name, input_html: { value: param_family.last_name }
        else
          f.input :last_name
        end

        f.input :gender, as: :select, collection: gender_select
        datepicker_input(f, :birthdate)
      end

      f.inputs 'Contact' do
        f.input :email
        f.input :phone
        f.input :emergency_contact
      end

      f.inputs do
        select_ministry_widget(f)
        f.input :department
      end

      f.inputs 'Attendance' do
        f.input :conferences
        f.input :courses
      end
    end
  end
end
