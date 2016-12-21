ActiveAdmin.register Family do
  include Families::Show
  include Families::Form

  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :street, :city, :state, :zip,
                :country_code, :registration_comment,
                housing_preference_attributes: [
                  :id, :housing_type, :roommates, :beds_count, :single_room,
                  :children_count, :bedrooms_count, :other_family,
                  :accepts_non_air_conditioned, :location1, :location2,
                  :location3, :confirmed_at
                ]

  index do
    selectable_column
    column :id
    column(:last_name) { |f| family_label(f) }
    column(:staff_number) { |f| code f.staff_number }
    column :street
    column :city
    column :state
    column(:country_code) { |f| country_name(f.country_code) }
    column :zip
    column(:registration_comment) { |f| html_summary(f.registration_comment) }
    column :created_at
    column :updated_at
    actions
  end

  filter :last_name_or_people_first_name_cont, label: 'Last Name or Family Member Name'
  filter :street
  filter :city
  filter :state
  filter :country_code, as: :select, collection: CountryHelper.country_select
  filter :zip
  filter :registration_comment
  filter :created_at
  filter :updated_at

  sidebar 'Family Members', only: [:edit] do
    attendees = family.attendees.load
    children  = family.children.load

    if attendees.any?
      h4 strong 'Attendees'
      ul do
        attendees.each do |p|
          li link_to(p.full_name, attendee_path(p))
        end
      end
    end

    if children.any?
      h4 strong 'Children'
      ul do
        children.each do |p|
          li link_to(p.full_name, child_path(p))
        end
      end
    end

    div class: 'action_items' do
      span link_to('New Attendee', new_attendee_path(family_id: family.id)), class: 'action_item'
      span link_to('New Child', new_child_path(family_id: family.id)), class: 'action_item'
    end
  end
end
