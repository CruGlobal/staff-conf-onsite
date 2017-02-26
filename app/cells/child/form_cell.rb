class Child::FormCell < ::FormCell
  property :child

  def show
    show_errors_if_any

    columns do
      column { left_column }
      column { right_column }
    end

    submit_buttons
  end

  private

  def person_cell
    @person_cell ||= cell('person/form', model, person: child)
  end

  def left_column
    child_inputs
    duration_inputs
    childcare_inputs
  end

  def right_column
    person_cell.call(:cost_adjustment_subform)
    person_cell.call(:stay_subform)
    cell('person/form_meal_exemptions', model, person: child).call
  end

  def child_inputs
    inputs 'Basic' do
      person_cell.call(:family_selector)

      input :first_name
      last_name_input

      input :gender, as: :select, collection: gender_select
      datepicker_input(model, :birthdate)
      input :grade_level, as: :select, collection: grade_level_select,
                          include_blank: true
      input :parent_pickup
      input :needs_bed
    end
  end

  def last_name_input
    if param_family
      input :last_name, input_html: { value: param_family.last_name }
    else
      input :last_name
    end
  end

  def duration_inputs
    inputs 'Duration' do
      datepicker_input(model, :arrived_at)
      datepicker_input(model, :departed_at)
    end
  end

  def childcare_inputs
    inputs 'Childcare' do
      input :childcare_weeks,
            label: 'Weeks of ChildCare',
            collection: childcare_weeks_select,
            multiple: true,
            hint: 'Please add all weeks needed'

      input :childcare_id,
            as: :select,
            collection: childcare_spaces_select,
            label: 'Childcare Spaces',
            prompt: 'please select'
    end
  end
end
