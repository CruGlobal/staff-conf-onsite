class Person::ShowMealExemptionsCell < ::ShowCell
  def meal_exemptions_panel
    panel "Meal Exemptions (#{person.meal_exemptions.size})", class: 'meal_exemptions' do
      person.meal_exemptions.any? ? meal_exemptions_table : strong('None')
    end
  end

  private

  def person
    @options.fetch(:person)
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
