class Child::ShowCell < ::ShowCell
  property :child

  def show
    columns do
      column { left_column }
      column { right_column }
    end

    active_admin_comments
  end

  private

  def person_cell
    @person_cell ||= cell('person/show', model, person: child)
  end

  def left_column
    child_attributes_table
    duration_table
    childcare_table
  end

  def right_column
    person_cell.call(:cost_adjustments)
    person_cell.call(:stays)
    temporary_stay_cost_panel
    person_cell.call(:meal_exemptions)
  end

  def child_attributes_table
    attributes_table do
      row :id
      personal_attributes
      row(:grade_level) { |c| grade_level_label(c) }
      row :parent_pickup
      row :needs_bed
      row :rec_center_pass_started_at
      row :rec_center_pass_expired_at
      row :created_at
      row :updated_at
    end
  end

  def personal_attributes
    row :first_name
    row :last_name
    row(:family) { |c| link_to family_label(c.family), family_path(c.family) }
    row(:gender) { |c| gender_name(c.gender) }
    row :birthdate
    row(:age, sortable: :birthdate) { |c| age_label(c) }
  end

  def duration_table
    panel 'Requested Arrival/Departure', class: 'duration' do
      attributes_table_for child do
        row :arrived_at
        row :departed_at
      end
    end
  end

  def childcare_table
    panel 'Childcare', class: 'childcare' do
      attributes_table_for child do
        row(:childcare) do |c|
          link_to chilcare_spaces_label(c.childcare), c.childcare if c.childcare
        end
        row(:childcare_weeks) { |c| childcare_weeks_list(c) }
      end
    end
  end

  # TODO: This is for client-demo purposes. This will be part of some report in
  #       the future.
  def temporary_stay_cost_panel
    panel 'Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = SumChildStayCost.call(child: child)
      if result.success?
        humanized_money_with_symbol result.total_charge
      else
        div(class: 'flash flash_error') { result.error }
      end
    end
  end
end
