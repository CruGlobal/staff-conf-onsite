module Attendees
  module Show
    def self.included(base)
      base.send :show do
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
    end
  end
end
