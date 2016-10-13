module Attendees
  module MealsShow
    MealsPanel = proc do
      panel 'Meals' do
        if attendee.meals.any?
          table do
            thead do
              tr do
                th 'Date'
                Meal::TYPES.each { |t| th t }
              end
            end
            tbody do
              attendee.meals.order_by_date.each do |date, types|
                tr do
                  td { strong l date, format: :month }
                  Meal::TYPES.each do |t|
                    td do
                      if types[t]
                        status_tag :yes, :meal_type
                      else
                        status_tag :no, :meal_type
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
