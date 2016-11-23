module Attendees
  module Show
    include People::ShowCostAdjustments
    include People::ShowMealExemptions

    def self.included(base)
      base.send :show do
        columns do
          instance_exec(&AttributesTable)

          column do
            instance_exec(&ConferencesPanel)
            instance_exec(&CoursesPanel)
            instance_exec(attendee, &CostAdjustmentsPanel)
            instance_exec(attendee, &MealExemptionsPanel)
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
            link_to last_name_label(a), family_path(a.family)
          end
          row :birthdate
          row('Age', sortable: :birthdate) { |a| age(a.birthdate) }
          row(:gender) { |a| gender_name(a.gender) }
          row(:email) { |a| mail_to(a.email) }
          row(:phone) { |a| format_phone(a.phone) }
          row :emergency_contact
          row(:ministry) do |a|
            if a.ministry_id.present?
              link_to a.ministry.to_s, ministry_path(a.ministry_id)
            end
          end
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
  end
end
