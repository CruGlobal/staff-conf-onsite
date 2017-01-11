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
    attributes_table do
      row :id
      row :name
      row :teachers
      row :location
      row :room
      row 'enrolled' do |childcare|
        childcare.children.count
      end
      row 'Students' do |childcare|
        childcare.children.each do |child|
          li "#{child.first_name} #{child.last_name}"
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors

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
