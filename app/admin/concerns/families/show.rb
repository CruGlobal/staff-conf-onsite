module Families
  module Show
    def self.included(base)
      base.send :show, title: ->(f) { PersonHelper.family_label(f) } do
        columns do
          column do
            instance_exec(&AttributesTable)
            instance_exec(&HousingPreferencesTable)
          end
          column do
            instance_exec(&AttendeesList)
            instance_exec(&ChildrenList)
          end
        end
        active_admin_comments
      end
    end

    AttributesTable = proc do
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

    HousingPreferencesTable = proc do
      panel 'Housing Preference' do
        attributes_table_for family.housing_preference do
          row(:housing_type) { |hp| housing_type_name(hp) }
          if family.housing_preference.try(:apartment?)
            row :children_count
            row :bedrooms_count
          end
          row :location1
          row :location2
          row :location3
          row :beds_count
          row(:roommates) { |hp| simple_format hp.roommates }
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

    AttendeesList = proc do
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

    ChildrenList = proc do
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
