module Attendees
  module Form
    include People::Form

    def self.included(base)
      base.send :form, FORM_OPTIONS do |f|
        f.semantic_errors

        instance_exec(f, &AttendeeInputs)
        instance_exec(f, attendee, &MealExemptionsSubform)

        f.actions
      end
    end

    AttendeeInputs = proc do |f|
      f.inputs 'Basic' do
        instance_exec(f, &FamilySelector)

        f.input :student_number
        f.input :first_name

        if param_family
          f.input :last_name, input_html: { value: param_family.last_name }
        else
          f.input :last_name
        end

        f.input :gender, as: :select, collection: gender_select
        f.input(
          :birthdate,
          as: :datepicker,
          datepicker_options: { changeYear: true, changeMonth: true }
        )
      end

      f.inputs 'Contact' do
        f.input :email
        f.input :phone
        f.input :emergency_contact
      end

      f.inputs do
        f.input :ministry
        f.input :department
      end

      f.inputs 'Attendance' do
        f.input :conferences
        f.input :courses
      end
    end
  end
end
