module Attendees
  module Form
    include FormMealExemptions

    def self.included(base)
      base.send :form do |f|
        f.semantic_errors

        instance_exec(f, &AttendeeInputs)
        instance_exec(f, &MealExemptionsSubform)

        f.actions
      end
    end

    AttendeeInputs = proc do |f|
      f.inputs 'Basic' do
        f.input :student_number
        f.input :first_name
        f.input :last_name
        f.input :gender, as: :select, collection: gender_select
        f.input(
          :birthdate,
          as: :datepicker,
          datepicker_options: { changeYear: true, changeMonth: true }
        )
        f.input :family
      end

      f.inputs 'Contact' do
        f.input :email
        f.input :phone
        f.input :emergency_contact
      end

      f.inputs do
        f.input :ministry
        f.input :staff_number
        f.input :department
      end

      f.inputs 'Attendance' do
        f.input :conferences
        f.input :courses
      end
    end
  end
end
