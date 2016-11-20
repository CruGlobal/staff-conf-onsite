ActiveAdmin.register Ministry do
  include Ministries::Show
  include Ministries::Form

  permit_params :name, :code, :name, :parent_id

  index do
    selectable_column
    column :id
    column :code
    column :name
    column(:parent) { |m| m.parent.to_s }
    column 'Members' do |m|
      link_to(m.people.count, attendees_path(q: { ministry_id_eq: m.id }))
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :code
  filter :name
  filter :created_at
  filter :updated_at
end
