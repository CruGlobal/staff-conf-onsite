ActiveAdmin.register Conference do
  permit_params :name, :description, :start_at, :end_at

  index do
    selectable_column
    column :id
    column(:name) { |c| h4 c.name }
    # TODO: Use format_cents when merged with cost-adjustments branch
    column :cents
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
      # TODO: Use format_cents when merged with cost-adjustments branch
      row :cents
      # rubocop:disable Rails/OutputSafety
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
      f.input :cents, as: :string
      f.input :description, as: :ckeditor
      f.input :start_at, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :end_at, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
    end
    f.actions
  end
end
