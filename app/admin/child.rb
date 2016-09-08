ActiveAdmin.register Child do
  menu parent: 'People', priority: 3

  permit_params :first_name, :last_name, :birthdate, :gender, :family

  index do
    selectable_column
    column :id
    column :first_name
    column(:last_name) do |c|
      link_to c.last_name, family_path(c.family) if c.family_id
    end
    column :birthdate
    column('Age', sortable: :birthdate) { |c| age(c.birthdate) }
    column(:gender) { |c| gender_name(c.gender) }
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :first_name
      row(:last_name) do |c|
        link_to c.last_name, family_path(c.family) if c.family_id
      end
      row :birthdate
      row(:gender) { |c| gender_name(c.gender) }
      row('Age', sortable: :birthdate) { |c| age(c.birthdate) }
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :gender, as: :select, collection: gender_select
      f.input :birthdate, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :family
    end
    f.actions
  end
end
