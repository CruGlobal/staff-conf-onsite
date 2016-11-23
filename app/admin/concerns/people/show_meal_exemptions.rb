module People
  module ShowMealExemptions
    MealExemptionsPanel = proc do |person|
      panel "Meal Exemptions (#{person.meal_exemptions.size})" do
        if person.meal_exemptions.any?
          table do
            thead do
              tr do
                th 'Date'
                MealExemption::TYPES.each { |t| th t }
              end
            end
            tbody do
              person.meal_exemptions.order_by_date.each do |date, types|
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
        else
          strong 'None'
        end
      end
    end
  end
end
