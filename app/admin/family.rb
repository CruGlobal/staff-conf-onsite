ActiveAdmin.register Family do
  menu parent: 'People', priority: 4

  permit_params :phone, :street, :city, :state, :zip, :country_code

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

  show title: ->(f) { PersonHelper.family_name(f) } do
    attributes_table do
      row :id
      row(:phone) { |f| format_phone(f.phone) }
      row :street
      row :city
      row :state
      row(:country_code) { |f| country_name(f.country_code) }
      row :zip
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form title: ->(f) { "Edit #{PersonHelper.family_name(f)}" } do |f|
    f.semantic_errors

    f.inputs :phone

    f.inputs 'Address' do
      f.input :street
      f.input :city
      f.input :state
      f.input :country_code, as: :select, collection: country_select, include_blank: false
      f.input :zip
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

  sidebar 'Family Members', only: [:show, :edit] do
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
