ActiveAdmin.register Family do
  include Families::Show

  menu parent: 'People', priority: 1

  permit_params(
    :phone, :street, :city, :state, :zip, :country_code,

    housing_preference_attributes: [
      :id, :housing_type, :children_count, :bedrooms_count, :location1,
      :location2, :location3, :beds_count, :roommates, :confirmed_at
    ]
  )

  index do
    selectable_column
    column :id
    column('Name') { |f| h4 family_name(f) }
    column(:phone) { |f| format_phone(f.phone) }
    column :street
    column :city
    column :state
    column(:country_code) { |f| country_name(f.country_code) }
    column :zip
    column :created_at
    column :updated_at
    actions
  end


  form title: ->(f) { "Edit #{PersonHelper.family_name(f)}" } do |f|
    f.semantic_errors

    f.inputs :phone

    f.inputs 'Address' do
      f.input :street
      f.input :city
      f.input :state
      f.input :country_code, as: :select, collection: country_select,
        include_blank: false
      f.input :zip
    end

    # Housing Preference sub-form
    for_housing_preference = [
      :housing_preference,
      f.object.housing_preference || f.object.build_housing_preference
    ]
    f.inputs 'Housing Preference', class: 'housing_preference_attributes',
        for: for_housing_preference do |hp|
      hp.input :housing_type, as: :select,
        collection: housing_type_select
      hp.input :children_count, wrapper_html: { class: :apartments_only }
      hp.input :bedrooms_count, wrapper_html: { class: :apartments_only }
      hp.input :location1
      hp.input :location2
      hp.input :location3
      hp.input :beds_count
      hp.input :roommates
      hp.input :confirmed_at, as: :datepicker
    end

    f.actions
  end

  filter :phone
  filter :street
  filter :city
  filter :state
  filter :country_code, as: :select, collection: CountryHelper.country_select
  filter :zip
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
  end
end
