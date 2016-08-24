ActiveAdmin.register Ministry do
  permit_params :name, :description

  index do
    selectable_column
    column :id
    column(:name) { |m| h4 m.name }
    column(:description) { |m| html_summary(m.description) }
    column 'Members' do |m|
      link_to(m.people.count, attendees_path(q: {ministry_id_eq: m.id}))
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :name
      row(:description) { |m| m.description.html_safe }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :description, as: :ckeditor
    end
    f.actions
  end
end
