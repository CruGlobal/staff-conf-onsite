module People
  # Defines the view for the Meal Exemptions subform, nested in a Person's form.
  class FormMealExemptionsCell < ::FormCell
    def show
      inputs 'Meal Exemptions', class: 'meal_exemptions_attributes' do
        # This warning is hidden via Javascript
        h4 class: 'meal_exemptions_attributes__warning' do
          text_node 'Checked Meal Exemptions will be '
          strong 'deleted'
        end

        meal_exemptions_table
      end
    end

    private

    def person
      @options.fetch(:person)
    end

    # A table of all of the meals this person has opted out of. Each row
    # represents a day, and each column a single meal exemption in that day
    def meal_exemptions_table
      table do
        meal_exemptions_table_header

        tbody do
          next_index = meal_exemptions_rows

          div(
            id: 'meal_exemptions_attributes__js',
            'data-nextindex' => next_index,
            'data-types' => MealExemption::TYPES.join(',')
          )
        end
      end
    end

    def meal_exemptions_table_header
      thead do
        tr do
          th 'Date'
          MealExemption::TYPES.each { |t| th t }
        end
      end
    end

    # Creates a new row for each Date. ex:
    # |     Date     |  Breakfast  |   Lunch    |   Dinner   |
    # |  October 20  |  [EXEMPT]   |  [EXEMPT]  |  [EXEMPT]  |
    #
    # @return [Fixnum] the next available index
    def meal_exemptions_rows
      index = (MealExemption.last.try(:id) || -1) + 1

      person.meal_exemptions.order_by_date.each do |date, types|
        meal_exemptions_row(date, types, index)
      end

      index
    end

    def meal_exemptions_row(date, types, index)
      tr do
        td { strong l date, format: :month }
        MealExemption::TYPES.each do |t|
          meal_exemption_column(t, date, types, index)
        end
      end
    end

    def meal_exemption_column(t, date, types, index)
      td do
        name = "#{person.class.name.underscore}[meal_exemptions_attributes]"
        name = meal_exemption_name(types[t], name, index)

        # Delete record checkbox
        insert_tag(
          Arbre::HTML::Input,
          type: :checkbox,
          name: "#{name}[_destroy]",
          checked: types[t].blank?,
          class: 'meal_exemptions_attributes__destroy_toggle'
        )

        meal_exemption_attributes(t, name, date)
      end
    end

    def meal_exemption_name(type, name, index)
      if type.present?
        name = "#{name}[#{type.id}]"
        meal_exemption_id_input(name, type.id)
      else
        name = "#{name}[#{index}]"
      end

      name
    end

    def meal_exemption_id_input(name, id)
      insert_tag(
        Arbre::HTML::Input,
        type: :hidden,
        name: "#{name}[id]",
        value: id
      )
    end

    def meal_exemption_attributes(t, name, date)
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
