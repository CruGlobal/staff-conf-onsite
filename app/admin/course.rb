ActiveAdmin.register Course do
  permit_params :name, :start_at, :end_at

  index do
    selectable_column
    column :id
    column(:name) { |c| h4 c.name }
    column :stat_at
    column :end_at
    column 'Attendees' do |c|
      link_to c.attendees.count, ''
    end
    column :created_at
    column :updated_at
    actions
  end

end
