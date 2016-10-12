module Attendees
  module Form
    def self.included(base)
      base.send :form do |f|
        f.semantic_errors

        f.inputs 'Basic' do
          f.input :student_number
          f.input :first_name
          f.input :last_name
          f.input :gender, as: :select, collection: gender_select
          f.input(
            :birthdate,
            as: :datepicker,
            datepicker_options: { changeYear: true, changeMonth: true }
          )
          f.input :family
        end

        f.inputs 'Contact' do
          f.input :email
          f.input :phone
          f.input :emergency_contact
        end

        f.inputs do
          f.input :ministry
          f.input :staff_number
          f.input :department
        end

        f.inputs 'Attendance' do
          f.input :conferences
          f.input :courses
        end

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
                        name = "#{name}[#{next_index}]"
                        next_index += 1
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

              div(id: 'meals_attributes__js', 'data-nextindex' => next_index,
                  'data-types' => Meal::TYPES.join(','))
            end
          end
        end

        f.actions
      end
    end
  end
end
