ActiveAdmin.register Ministry do
  permit_params :name, :code

  index do
    selectable_column
    column :id
    column(:name) { |m| h4 m.name }
    column :code
    column 'Members' do |m|
      link_to(m.people.count, attendees_path(q: { ministry_id_eq: m.id }))
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :name
      row(:code) { |m| ministry_code_label(m.code) }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :code, as: :select, collection: ministry_code_select
    end
    f.actions
  end
end
