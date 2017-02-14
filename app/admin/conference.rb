ActiveAdmin.register Conference do
  permit_params :name, :description, :start_at, :end_at, :price

  index do
    selectable_column
    column :id
    column(:name) { |c| h4 c.name }
    column(:price) { |c| humanized_money_with_symbol(c.price) }
    column(:description) { |c| html_summary(c.description) }
    column :start_at
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
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row(:price) { |c| humanized_money_with_symbol(c.price) }
          row(:description) { |c| c.description.try(:html_safe) }
          row :start_at
          row :end_at
          row :created_at
          row :updated_at
        end
      end

      column do
        size = conference.attendees.size
        panel "Attendees (#{size})" do
          if size.positive?
            ul do
              conference.attendees.each do |a|
                li { link_to(a.full_name, a) }
              end
            end
          else
            strong 'None'
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    show_errors_if_any(f)

    f.inputs do
      f.input :name
      money_input_widget(f, :price)
      f.input :description, as: :ckeditor
      datepicker_input(f, :start_at)
      datepicker_input(f, :end_at)
    end
    f.actions
  end
end
