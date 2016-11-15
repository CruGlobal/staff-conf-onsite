ActiveAdmin.register Family do
  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :street, :city, :state, :zip,
                :country_code

  index do
    selectable_column
    column :id
    column :last_name
    column(:staff_number) { |f| code f.staff_number }
    column :street
    column :city
    column :state
    column(:country_code) { |f| country_name(f.country_code) }
    column :zip
    column :created_at
    column :updated_at
    actions
  end

  show title: ->(f) { PersonHelper.family_label(f) } do
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

    active_admin_comments
  end

  form title: ->(f) { "Edit #{PersonHelper.family_label(f)}" } do |f|
    f.semantic_errors

    f.inputs 'Basic Info' do
      f.input :last_name
      f.input :staff_number
    end

    f.inputs 'Address' do
      f.input :street
      f.input :city
      f.input :state
      f.input :country_code, as: :select, collection: country_select, include_blank: false
      f.input :zip
    end
    f.actions
  end

  filter :last_name
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

    div class: 'action_items' do
      span link_to('New Attendee', new_attendee_path(family_id: family.id)), class: 'action_item'
      span link_to('New Child', new_child_path(family_id: family.id)), class: 'action_item'
    end
  end
end
