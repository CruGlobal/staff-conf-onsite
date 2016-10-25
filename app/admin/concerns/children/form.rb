module Children
  module Form
    include People::FormMealExemptions

    def self.included(base)
      base.send :form do |f|
        f.semantic_errors

        instance_exec(f, &AttendeeInputs)
        instance_exec(f, child, &MealExemptionsSubform)

        f.actions
      end
    end

    AttendeeInputs = proc do |f|
      f.inputs do
        f.input :first_name
        f.input :last_name
        f.input :family
        f.input :gender, as: :select, collection: gender_select
        f.input :birthdate, as: :datepicker, datepicker_options:
          { changeYear: true, changeMonth: true }
        f.input :grade_level
        f.input :parent_pickup
        f.input :needs_bed
        f.input :childcare_weeks,
                label: 'Weeks of ChildCare',
                collection: Childcare::CHILDCARE_WEEKS,
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
