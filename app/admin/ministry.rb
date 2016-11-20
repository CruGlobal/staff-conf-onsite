ActiveAdmin.register Ministry do
  include Ministries::Show

  permit_params :name, :code, :name, :parent_id

  index do
    selectable_column
    column :id
    column :code
    column(:name) { |m| h4 m.name }
    column :parent
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

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :code
      f.input :name
      select_ministry_widget(f, :parent)
    end
    f.actions
  end
end
