module Attendees
  # Defines the HTML for rendering a single {Attendee} record.
  module Show
    include People::ShowCostAdjustments
    include People::ShowMealExemptions
    include People::ShowStays

    def self.included(base)
      base.send :show do
        columns do
          column { instance_exec(&LEFT_COLUMN) }
          column { instance_exec(&RIGHT_COLUMN) }
        end

        active_admin_comments
      end
    end

    LEFT_COLUMN = proc do
      instance_exec(&ATTRIBUTES_TABLE)
      instance_exec(&DURATION_TABLE)
      instance_exec(&CONFERENCES_PANEL)
      instance_exec(&COURSES_PANEL)
      instance_exec(attendee, &COST_ADJUSTMENTS_PANEL)
    end

    RIGHT_COLUMN = proc do
      instance_exec(&ATTENDANCES_PANEL)
      instance_exec(attendee, &STAYS_PANEL)
      instance_exec(attendee, &MEAL_EXEMPTIONS_PANEL)
    end

    ATTRIBUTES_TABLE ||= proc do
      attributes_table do
        row :id
        row(:student_number) { |a| code a.student_number }
        row :first_name
        row :last_name
        row(:family) { |a| link_to family_label(a.family), family_path(a.family) }
        row :birthdate
        row(:age, sortable: :birthdate) { |a| age_label(a) }
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

    DURATION_TABLE ||= proc do
      panel 'Duration' do
        attributes_table_for attendee do
          row :arrived_at
          row :departed_at
        end
      end
    end

    CONFERENCES_PANEL ||= proc do
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

    COURSES_PANEL ||= proc do
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

    ATTENDANCES_PANEL ||= proc do
      panel 'Attendances' do
        attendances = attendee.course_attendances.includes(:course)
        if attendances.any?
          table_for attendances.sort_by { |a| a.course.name } do
            column :course
            column :grade
            column :seminary_credit
          end
        else
          strong 'None'
        end
      end
    end
  end
end
