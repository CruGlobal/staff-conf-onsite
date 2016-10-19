module Attendees
  module ShowMealExemptions
    MealExemptionsPanel = proc do
      panel "Meal Exemptions (#{attendee.meal_exemptions.size})" do
        if attendee.meal_exemptions.any?
          table do
            thead do
              tr do
                th 'Date'
                MealExemption::TYPES.each { |t| th t }
              end
            end
            tbody do
              attendee.meal_exemptions.order_by_date.each do |date, types|
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
