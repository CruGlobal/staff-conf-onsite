ActiveAdmin.register Attendee do
  remove_filter :family # Adds N+1 additional quries to the index page

  menu parent: 'People', priority: 2

  permit_params :first_name, :last_name, :email, :emergency_contact, :phone,
                :birthdate, :student_number, :staff_number, :gender,
                :department, :family_id, :ministry_id, conference_ids: [],
                course_ids: [], meals_attributes: [:id, :_destroy, :date,
                                                   :meal_type]

  index do
    selectable_column
    column :id
    column(:student_number) { |a| h4 a.staff_number }
    column :first_name
    column(:last_name) do |a|
      link_to a.last_name, family_path(a.family) if a.family_id
    end
    column :birthdate
    column('Age', sortable: :birthdate) { |a| age(a.birthdate) }
    column(:gender) { |a| gender_name(a.gender) }
    column(:email) { |a| mail_to(a.email) }
    column(:phone) { |a| format_phone(a.phone) }
    column :emergency_contact
    column :staff_number
    column :department
    column :created_at
    column :updated_at
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row(:staff_number) { |a| code a.staff_number }
          row :first_name
          row(:last_name) do |a|
            link_to a.last_name, family_path(a.family) if a.family_id
          end
          row :birthdate
          row('Age', sortable: :birthdate) { |a| age(a.birthdate) }
          row(:gender) { |a| gender_name(a.gender) }
          row(:email) { |a| mail_to(a.email) }
          row(:phone) { |a| format_phone(a.phone) }
          row :emergency_contact
          row :staff_number
          row :department
          row 'Meals' do |a|
            link_to a.meals.count, attendee_meals_path(a)
          end
          row 'Cost Adjustments' do |a|
            link_to a.cost_adjustments.count, cost_adjustments_path(q: { person_id_eq: a.id })
          end
          row :created_at
          row :updated_at
        end
      end

      column do
        panel 'Conferences' do
          if attendee.conferences.any?
            ul do
              attendee.conferences.each do |c|
                li { link_to(c.name, c) }
              end
            end
          else
            strong 'None'
          end
        end

        panel 'Courses' do
          if attendee.courses.any?
            ul do
              attendee.courses.each do |c|
                li { link_to(c.name, c) }
              end
            end
          else
            strong 'None'
          end
        end

        panel 'Cost Adjustments' do
          if attendee.cost_adjustments.any?
            ul do
              attendee.cost_adjustments.each do |c|
                li { link_to(humanized_money_with_symbol(c.price), c) }
              end
            end
          else
            strong 'None'
          end
        end

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
                puts date
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
    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Basic' do
      f.input :student_number
      f.input :first_name
      f.input :last_name
      f.input :gender, as: :select, collection: gender_select
      f.input :birthdate, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
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
      h4 class: 'meals_attributes__warning' do
        text_node "Checked Meals will be "
        strong 'deleted'
      end
      table do
        thead do
          tr do
            th 'Date'
            Meal::TYPES.each { |t| th t }
          end
        end
        tbody do
          next_id = Meal.last.id + 1

          attendee.meals.order_by_date.each do |date, types|
            tr do
              td { strong l date, format: :month }
              Meal::TYPES.each do |t|
                td do
                  name = "attendee[meals_attributes]"
                  exists = false

                  if types[t]
                    exists = true
                    name = "#{name}[#{types[t].id}]"
                    insert_tag Arbre::HTML::Input, type: :hidden,
                      name: "#{name}[id]", value: types[t].id
                  else
                    name = "#{name}[#{next_id}]"
                    next_id += 1
                  end

                  insert_tag Arbre::HTML::Input, type: :checkbox,
                    name: "#{name}[_destroy]", checked: !exists,
                    class: 'meals_attributes__destroy_toggle'
                  insert_tag Arbre::HTML::Input, type: :hidden,
                    name: "#{name}[date]", value: date
                  insert_tag Arbre::HTML::Input, type: :hidden,
                    name: "#{name}[meal_type]", value: t
                end
              end
            end
          end
        end
      end
    end

    f.actions
  end

  controller do
    def scoped_collection
      super.includes(:family)
    end
  end
end
