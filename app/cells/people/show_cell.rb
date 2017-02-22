module People
  class ShowCell < ::ShowCell
    def meal_exemptions
      panel "Meal Exemptions (#{person.meal_exemptions.size})" do
        person.meal_exemptions.any? ? meal_exemptions_table : strong('None')
      end
    end

    def stays
      panel 'Housing Assignments' do
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

    def cost_adjustments
      panel "Cost Adjustments (#{person.cost_adjustments.size})" do
        person.cost_adjustments.any? ? cost_adjusments_list : strong('None')
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
            link_to("#{humanized_money_with_symbol(ca.price)} - #{cost_type_name(ca)}", ca)
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
      row 'Duration' do |stay|
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
          t = stay.housing_type

          if types.include?(t.to_sym)
            simple_format_attr(stay, attribute)
          else
            span('N/A', class: 'empty')
          end
        end
      end
    end

    def meal_exemptions_table
      table do
        meal_exemptions_header

        tbody do
          person.meal_exemptions.order_by_date.each do |date, types|
            meal_exemptions_row(date, types)
          end
        end
      end
    end

    def meal_exemptions_header
      thead do
        tr do
          th 'Date'
          MealExemption::TYPES.each { |t| th t }
        end
      end
    end

    def meal_exemptions_row(date, types)
      tr do
        td { strong l date, format: :month }
        MealExemption::TYPES.each do |t|
          td do
            if types[t]
              status_tag :yes, :meal_type, label: 'exempt'
            else
              status_tag :no, :meal_type, label: 'accept'
            end
          end
        end
      end
    end
  end
end
