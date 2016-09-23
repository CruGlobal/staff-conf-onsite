ActiveAdmin.register Course do
  permit_params :name, :start_at, :end_at

  index do
    selectable_column
    column :id
    column(:name) { |c| h4 c.name }
    column(:description) { |m| html_summary(m.description) }
    column :stat_at
    column :end_at
    column 'Attendees' do |c|
      link_to c.attendees.count, ''
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :description
  filter :start_at
  filter :end_at
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :name
      # rubocop:disable Rails/OutputSafety
      row(:description) { |m| m.description.try(:html_safe) }
      row :stat_at
      row :end_at
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
      f.input :start_at, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :end_at, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
    end
    f.actions
  end
end
