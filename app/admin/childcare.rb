ActiveAdmin.register Childcare do
  permit_params :name, :teachers, :location, :room

  index do
    selectable_column
    column :id
    column :name
    column :teachers
    column :location
    column :room
    column :created_at
    column :updated_at
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row :teachers
          row :location
          row :room
          row :created_at
          row :updated_at
        end
      end

      column do
        size = childcare.children.size
        panel "Children (#{size})" do
          if size.positive?
            ul do
              childcare.children.each do |c|
                li { link_to(c.full_name, c) }
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
      f.input :name, hint: 'Title of class including grade'
      f.input :teachers,
              hint: 'If more than one teacher please use commas between names'
      f.input :location
      f.input :room
    end

    f.actions
  end
end
