module Children
  # Defines the form for creating and editong {Show} records.
  module Form
    include People::Form

    def self.included(base)
      base.send :form, FORM_OPTIONS do |f|
        f.semantic_errors

        instance_exec(f, &ATTENDEE_INPUTS)
        instance_exec(f, child, &MEAL_EXEMPTIONS_SUBFORM)

        f.actions
      end
    end

    ATTENDEE_INPUTS ||= proc do |f|
      f.inputs do
        instance_exec(f, &FAMILY_SELECTOR)

        f.input :first_name

        if param_family
          f.input :last_name, input_html: { value: param_family.last_name }
        else
          f.input :last_name
        end

        f.input :gender, as: :select, collection: gender_select
        f.input :birthdate, as: :datepicker, datepicker_options:
          { changeYear: true, changeMonth: true }
        f.input :grade_level, as: :select, collection: grade_level_select
        f.input :parent_pickup
        f.input :needs_bed

        f.input :childcare_weeks,
                label: 'Weeks of ChildCare',
                collection: childcare_weeks_select,
                multiple: true,
                hint: 'Please add all weeks needed'
      end

      f.inputs 'Assign ChildCare Spaces' do
        f.input :childcare_id,
                as: :select,
                collection: childcare_spaces_select,
                label: 'Childcare Spaces',
                prompt: 'please select'
      end
    end
  end
end
