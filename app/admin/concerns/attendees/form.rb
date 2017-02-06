module Attendees
  # Defines the form for creating and editong {Attendee} records.
  module Form
    include People::Form

    # rubocop:disable MethodLength
    def self.included(base)
      base.send :form, FORM_OPTIONS do |f|
        f.semantic_errors

        columns do
          column do
            instance_exec(f, &ATTRIBUTES_COLUMN)
          end

          column do
            instance_exec(f, &COURSE_ATTENDANCES_SUBFORM)
            instance_exec(f, attendee, &STAY_SUBFORM)
          end

          column do
            instance_exec(f, attendee, &COST_ADJUSTMENT_SUBFORM)
            instance_exec(f, attendee, &MEAL_EXEMPTIONS_SUBFORM)
          end
        end

        f.actions
      end
    end

    ATTRIBUTES_COLUMN ||= proc do |f|
      instance_exec(f, &DURATION_INPUTS)
      instance_exec(f, &CONTACT_INPUTS)
      instance_exec(f, &MINISTRY_INPUTS)
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
    end

    DURATION_INPUTS ||= proc do |f|
      f.inputs 'Duration' do
        datepicker_input(f, :arrived_at)
        datepicker_input(f, :departed_at)
      end
    end

    CONTACT_INPUTS ||= proc do |f|
      f.inputs 'Contact' do
        f.input :email
        f.input :phone
        f.input :emergency_contact
      end
    end

    MINISTRY_INPUTS ||= proc do |f|
      f.inputs do
        select_ministry_widget(f)
        f.input :department
        f.input :conferences
      end
    end

    COURSE_ATTENDANCES_SUBFORM ||= proc do |form|
      collection = [:course_attendances, form.object.course_attendances]

      panel 'Attendances' do
        form.has_many :course_attendances, heading: nil, collection:
            collection, new_record: 'Add New Attendance' do |f|
          f.input :course
          f.input :grade, collection: course_grade_select
          f.input :seminary_credit
          f.input :_destroy, as: :boolean, wrapper_html: { class: 'destroy' }
        end
      end
    end
  end
end
