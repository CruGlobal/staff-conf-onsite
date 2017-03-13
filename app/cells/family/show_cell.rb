class Family::ShowCell < ::ShowCell
  property :family

  def show
    columns do
      column do
        family_attributes_table
        housing_preference_table
      end
      column do
        attendees_list
        children_list
        temporary_stay_cost_panel
      end
    end
    active_admin_comments
  end

  private

  def family_attributes_table
    attributes_table do
      row :id
      row :last_name
      row(:staff_number) do |f|
        code f.staff_number
        status_tag :yes, label: 'Chargeable' if f.chargeable_staff_number?
      end
      address_rows
      row :created_at
      row :updated_at
    end
  end

  def address_rows
    row :street
    row :city
    row :state
    row(:country_code) { |f| country_name(f.country_code) }
    row :zip
  end

  def housing_preference_table
    panel 'Housing Preference' do
      attributes_table_for family.housing_preference do
        row(:housing_type) { |hp| housing_type_name(hp) }

        housing_type_field_rows

        row(:registration_comment) do
          html_full(family.registration_comment) || strong('N/A')
        end
        confirmed_at_row
      end
    end
  end

  def confirmed_at_row
    row :confirmed_at do |hp|
      if hp.confirmed_at.present?
        status_tag :yes, label: "confirmed on #{l hp.confirmed_at, format: :month}"
      else
        status_tag :no, label: 'unconfirmed'
      end
    end
  end

  def housing_type_field_rows
    housing_type = family.housing_preference.housing_type.to_sym

    HousingPreference::HOUSING_TYPE_FIELDS.each do |attr, types|
      if types.include?(housing_type)
        row(attr) { |hp| simple_format_attr(hp, attr) }
      end
    end
  end

  def attendees_list
    attendees = family.attendees.load

    panel 'Attendees' do
      if attendees.any?
        ul do
          attendees.each do |p|
            li link_to(p.full_name, attendee_path(p))
          end
        end
      else
        strong 'None'
      end
    end
  end

  def children_list
    children = family.children.load

    panel 'Children' do
      if children.any?
        ul do
          children.each do |p|
            li link_to(p.full_name, child_path(p))
          end
        end
      else
        strong 'None'
      end
    end
  end

  # TODO: This is for client-demo purposes. This will be part of some report in
  #       the future.
  def temporary_stay_cost_panel
    panel 'Children Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = SumFamilyChildrenStayCost.call(family: family)
      if result.success?
        temporary_stay_cost_table(result)
      else
        div(class: 'flash flash_error') { result.error }
      end
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
end
