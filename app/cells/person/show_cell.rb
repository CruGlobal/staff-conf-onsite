class Person::ShowCell < ::ShowCell
  def meal_exemptions
    cell('person/show_meal_exemptions', model, person: person).call(:meal_exemptions_panel)
  end

  def stays
    panel "Housing Assignments (#{person.stays.size})", class: 'stays' do
      person.stays.any? ? stays_table : strong('None')
    end
  end

  def cost_adjustments
    panel "Cost Adjustments (#{person.cost_adjustments.size})", class: 'cost_adjustments' do
      person.cost_adjustments.any? ? cost_adjusments_list : strong('None')
    end
  end

  # TODO: This is for client-demo purposes. This will be part of some report in
  #       the future.
  def rec_pass_cost_panel
    panel 'Rec Pass Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = ChargePersonRecPassCost.call(person: person)
      cell('cost_adjustment/summary', self, result: result).call
    end
  end

  private

  def person
    @options.fetch(:person)
  end

  def cost_adjusments_list
    ul do
      person.cost_adjustments.each do |ca|
        li do
          link_to("#{cost_adjustment_amount(ca)} - #{cost_type_name(ca)}", ca)
        end
      end
    end
  end

  def housing_rows
    row(:housing_type) { |stay| strong housing_type_label(stay.housing_type) }
    housing_facility_row
    row :housing_unit
  end

  def housing_facility_row
    row(:housing_facility) do |stay|
      facility = stay.housing_unit.try(:housing_facility)
      link_to facility.name, housing_facility_path(facility) if facility
    end
  end

  def duration_row
    row 'Requested Arrival/Departure' do |stay|
      if stay.arrived_at.present? && stay.departed_at.present?
        pluralize (stay.departed_at.mjd - stay.arrived_at.mjd), 'Day'
      else
        strong 'N/A'
      end
    end
  end

  def housing_field_rows
    Stay::HOUSING_TYPE_FIELDS.each do |attribute, types|
      row attribute do |stay|
        if types.include?(stay.housing_type.to_sym)
          simple_format_attr(stay, attribute)
        else
          span('N/A', class: 'empty')
        end
      end
    end
  end

  def stays_table
    attributes_table_for person.stays.order(:arrived_at) do
      housing_rows
      row :arrived_at
      row :departed_at
      duration_row
      housing_field_rows
      row(:comment) { |stay| html_full stay.comment }
    end
  end
end
