ActiveAdmin.register Childcare do
  permit_params :title, :teachers, :address, :cost, :start_date, :end_date

  index do
    selectable_column
    column :id
    column :title
    column :teachers
    column :address
    column :start_date
    column :end_date
    column :cost
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :teachers
      row :address
      row :start_date
      row :end_date
      row 'enrolled' do |childcare|
        childcare.children.count
      end
      row 'Students' do |childcare|
        childcare.children.each do |child|
          li "#{child.first_name} #{child.last_name}"
        end
      end
      row :cost
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :title, hint: 'Title of class including grade'
      f.input :teachers,
              hint: 'If more than one teacher please use commas between names'
      f.input :address, hint: 'Include address of building and room number'
      f.input :start_date
      f.input :end_date
      f.input :cost
    end

    f.actions
  end
end
