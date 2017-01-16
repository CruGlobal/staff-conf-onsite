module Families
  # Defines the HTML for rendering a single {Family} record.
  module Show
    def self.included(base)
      base.send :show, title: ->(f) { PersonHelper.family_label(f) } do
        columns do
          column do
            instance_exec(&ATTRIBUTES_TABLE)
            instance_exec(&HOUSING_PREFERENCES_TABLE)
          end
          column do
            instance_exec(&ATTENDEES_LIST)
            instance_exec(&CHILDREN_LIST)
          end
        end
        active_admin_comments
      end
    end
    ATTRIBUTES_TABLE ||= proc do
      attributes_table do
        row :id
        row :last_name
        row(:staff_number) { |f| code f.staff_number }
        row :street
        row :city
        row :state
        row(:country_code) { |f| country_name(f.country_code) }
        row :zip
        row :created_at
        row :updated_at
      end
    end

    HOUSING_PREFERENCES_TABLE ||= proc do
      panel 'Housing Preference' do
        attributes_table_for family.housing_preference do
          row(:housing_type) { |hp| housing_type_name(hp) }

          instance_exec(&HOUSING_TYPE_FIELD_ROWS)

          row(:registration_comment) do
            html_full(family.registration_comment) || strong('N/A')
          end

          row :confirmed_at do |hp|
            if hp.confirmed_at.present?
              status_tag :yes, label: "confirmed on #{l hp.confirmed_at, format: :month}"
            else
              status_tag :no, label: 'unconfirmed'
            end
          end
        end
      end
    end

    HOUSING_TYPE_FIELD_ROWS ||= proc do
      housing_type = family.housing_preference.housing_type.to_sym

      HousingPreference::HOUSING_TYPE_FIELDS.each do |attr, types|
        if types.include?(housing_type)
          row(attr) { |hp| simple_format_attr(hp, attr) }
        end
      end
    end

    ATTENDEES_LIST ||= proc do
      attendees = family.attendees.load

      panel 'Attendees' do
        if attendees.any?
          ul do
            attendees.each do |p|
              li link_to(p.full_name, attendee_path(p))
            end
          end
        else
          strong 'None'
        end
      end
    end

    CHILDREN_LIST ||= proc do
      children = family.children.load

      panel 'Children' do
        if children.any?
          ul do
            children.each do |p|
              li link_to(p.full_name, child_path(p))
            end
          end
        else
          strong 'None'
        end
      end
    end
  end
end
