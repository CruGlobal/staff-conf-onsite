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
    temporary_hot_lunch_cost_panel
    person_cell.call(:rec_pass_cost_panel)
  end

  def right_column
    person_cell.call(:stays)
    person_cell.call(:cost_adjustments)
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
        row :childcare_deposit
        row(:childcare_weeks) { |c| childcare_weeks_list(c) }
        row(:hot_lunch_weeks) { |c| hot_lunch_weeks_list(c) }
        row :childcare_comment
      end
    end
  end

  # TODO: This is for client-demo purposes. This will be part of some report in
  #       the future.
  def temporary_stay_cost_panel
    panel 'Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = ChargeChildStays.call(child: child)

      if result.success?
        temporary_stay_individual_dorms_cost_list
        temporary_stay_cost_table(result)
      else
        div(class: 'flash flash_error') { result.error }
      end
    end
  end

  def temporary_stay_individual_dorms_cost_list
    dorm_stays = child.stays.select { |s| s.housing_type == 'dormitory' }
    return if dorm_stays.empty?

    h4 'Dormatory Stays:'
    dl do
      dorm_stays.each do |stay|
        dt { join_stay_dates(stay) }
        dd { temporary_stay_individual_dorms_cost_list_item(stay) }
      end
    end
  end

  def temporary_stay_individual_dorms_cost_list_item(stay)
    result = SingleChildDormitoryStayCost.call(child: child, stay: stay)
    if result.success?
      text_node humanized_money_with_symbol result.total
    else
      div(class: 'flash flash_error') { result.error }
    end
  end

  def temporary_stay_cost_table(result)
    table do
      temporary_stay_cost_table_head
      tr do
        td { humanized_money_with_symbol result.subtotal }
        td { humanized_money_with_symbol result.total_adjustments * -1 }
        td { humanized_money_with_symbol result.total }
      end
    end
  end

  def temporary_stay_cost_table_head
    tr do
      th { 'Sub-Total' }
      th { 'Adjustments' }
      th { 'Total' }
    end
  end

  def temporary_hot_lunch_cost_panel
    panel 'Hot Lunch Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = ChargeChildHotLunchCost.call(child: child)
      cell('cost_adjustment/summary', self, result: result).call
    end
  end
end
