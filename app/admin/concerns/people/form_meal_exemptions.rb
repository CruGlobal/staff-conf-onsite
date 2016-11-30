module People
  # Defines the view for the Meal Exemptions subform, nested in a Person's form.
  module FormMealExemptions
    MEAL_EXEMPTIONS_SUBFORM ||= proc do |f, person|
      f.inputs 'Meal Exemptions', class: 'meal_exemptions_attributes' do
        # This warning is hidden via Javascript
        h4 class: 'meal_exemptions_attributes__warning' do
          text_node 'Checked Meal Exemptions will be '
          strong 'deleted'
        end

        # A table of all of the meals this person has opted out of. Each row
        # represents a day, and each column a single meal exemption in that day
        table do
          thead do
            tr do
              th 'Date'
              MealExemption::TYPES.each { |t| th t }
            end
          end

          tbody do
            next_index = (MealExemption.last.try(:id) || -1) + 1

            # Creates a new row for each Date. ex:
            # |     Date     |  Breakfast  |   Lunch     |  Dinner   |
            # |  October 20  |  [EXEMPT]   |  [EXEMPT]  |  [EXEMPT]  |
            person.meal_exemptions.order_by_date.each do |date, types|
              instance_exec(person, date, types, next_index, &DATE_TABLE_ROW)
              next_index += 1
            end

            div(
              id: 'meal_exemptions_attributes__js',
              'data-nextindex' => next_index,
              'data-types' => MealExemption::TYPES.join(',')
            )
          end
        end
      end
    end

    DATE_TABLE_ROW ||= proc do |person, date, types, index|
      tr do
        td { strong l date, format: :month }

        MealExemption::TYPES.each do |t|
          td do
            name = "#{person.class.name.underscore}[meal_exemptions_attributes]"
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
              class: 'meal_exemptions_attributes__destroy_toggle'
            )

            # Meal Exemption Attributes
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
