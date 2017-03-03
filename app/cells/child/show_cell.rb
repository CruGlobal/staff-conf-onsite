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
    person_cell.call(:cost_adjustments)
  end

  def right_column
    person_cell.call(:meal_exemptions)
    person_cell.call(:stays)
  end

  def child_attributes_table
    attributes_table do
      row :id
      personal_attributes
      row(:grade_level) { |c| grade_level_label(c) }
      row :childcare
      row(:childcare_weeks) { |c| childcare_weeks_list(c) }
      row :parent_pickup
      row :needs_bed
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
    panel 'Duration', class: 'duration' do
      attributes_table_for child do
        row :arrived_at
        row :departed_at
      end
    end
  end
end
