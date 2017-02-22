ActiveAdmin.register Family do
  extend Rails.application.helpers

  index { cell('families/index', self).call }
  show(title: ->(f) { family_label(f) }) { cell('families/show', self).call }
  form title: ->(f) { f.new_record? ? 'New Family' : "Edit #{family_label(f)}" } do |f|
    cell('families/form', f).call
  end
  sidebar('Family Members', only: [:edit]) { cell('families/sidebar', self).call }

  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :street, :city, :state, :zip,
                :country_code, :registration_comment,
                housing_preference_attributes: [
                  :id, :housing_type, :roommates, :beds_count, :single_room,
                  :children_count, :bedrooms_count, :other_family,
                  :accepts_non_air_conditioned, :location1, :location2,
                  :location3, :confirmed_at
                ]

  filter :last_name_or_people_first_name_cont, label: 'Last Name or Family Member Name'
  filter :street
  filter :city
  filter :state
  filter :country_code, as: :select, collection: country_select
  filter :zip
  filter :registration_comment
  filter :created_at
  filter :updated_at
end
