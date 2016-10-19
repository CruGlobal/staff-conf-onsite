module Attendees
  module Show
    include ShowMealExemptions

    def self.included(base)
      base.send :show do
        columns do
          instance_exec(&AttributesTable)

          column do
            instance_exec(&ConferencesPanel)
            instance_exec(&CoursesPanel)
            instance_exec(&CostAdjustmentsPanel)
            instance_exec(&MealExemptionsPanel)
          end
        end

        active_admin_comments
      end
    end

    AttributesTable = proc do
      column do
        attributes_table do
          row :id
          row(:student_number) { |a| code a.student_number }
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
          row(:staff_number) { |a| code a.staff_number }
          row :department
          row :created_at
          row :updated_at
        end
      end
    end

    ConferencesPanel = proc do
      panel "Conferences (#{attendee.conferences.size})" do
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
    end

    CoursesPanel = proc do
      panel "Courses (#{attendee.courses.size})" do
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
    end

    CostAdjustmentsPanel = proc do
      panel "Cost Adjustments (#{attendee.cost_adjustments.size})" do
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
    end
  end
end
