module Attendees
  # Defines the view for the Meals subform, nested in the Attendee form.
  module MealsSubform
    MealsSubform = proc do |f|
      f.inputs 'Meals', class: 'meals_attributes' do
        # This warning is hidden via Javascript
        h4 class: 'meals_attributes__warning' do
          text_node 'Checked Meals will be '
          strong 'deleted'
        end

        # A table of all of the meals this attendee has signed up for. Each
        # row represents a day, and each column a single meal in that day
        table do
          thead do
            tr do
              th 'Date'
              Meal::TYPES.each { |t| th t }
            end
          end

          tbody do
            next_index = Meal.last.id + 1

            # Creates a new row for each Date. ex:
            # |    Date    | Breakfast |   Lunch   |  Dinner  |
            # | October 20 |   [YES]   |   [YES]   |  [Yes]   |
            attendee.meals.order_by_date.each do |date, types|
              instance_exec(date, types, next_index, &DateTableRow)
              next_index += 1
            end

            div(id: 'meals_attributes__js', 'data-nextindex' => next_index,
                'data-types' => Meal::TYPES.join(','))
          end
        end
      end
    end

    DateTableRow = proc do |date, types, index|
      tr do
        td { strong l date, format: :month }

        Meal::TYPES.each do |t|
          td do
            name = 'attendee[meals_attributes]'
            record_exists_in_database = types[t].present?

            if record_exists_in_database
              name = "#{name}[#{types[t].id}]"
              insert_tag(
                Arbre::HTML::Input,
                type: :hidden,
                name: "#{name}[id]",
                value: types[t].id
              )
            else
              name = "#{name}[#{index}]"
            end

            # Delete record checkbox
            insert_tag(
              Arbre::HTML::Input,
              type: :checkbox,
              name: "#{name}[_destroy]",
              checked: !record_exists_in_database,
              class: 'meals_attributes__destroy_toggle'
            )

            # Meal Attributes
            insert_tag(
              Arbre::HTML::Input,
              type: :hidden,
              name: "#{name}[date]",
              value: date
            )
            insert_tag(
              Arbre::HTML::Input,
              type: :hidden,
              name: "#{name}[meal_type]",
              value: t
            )
          end
        end
      end
    end
  end
end
