module Attendees
  module Form
    include People::FormMealExemptions

    def self.included(base)
      base.send :form do |f|
        f.semantic_errors

        instance_exec(f, &AttendeeInputs)
        instance_exec(f, attendee, &MealExemptionsSubform)

        f.actions
      end
    end

    AttendeeInputs = proc do |f|
      f.inputs do
        f.input :family, selected: param_family.try(:id)
      end

      f.inputs 'Basic' do
        f.input :student_number
        f.input :first_name

        if param_family
          f.input :last_name, hint: t('misc.family.last_name_default', name:
                                      param_family.last_name)
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
