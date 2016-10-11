ActiveAdmin.register Child do
  menu parent: 'People', priority: 3

  permit_params :first_name, :last_name, :birthdate, :gender, :family, :parent_pickup, :needs_bed, :grade_level, childcare_weeks: []

  index do
    selectable_column
    column :id
    column :first_name
    column(:last_name) do |c|
      link_to c.last_name, family_path(c.family) if c.family_id
    end
    column(:gender) { |c| gender_name(c.gender) }
    column :birthdate
    column('Age', sortable: :birthdate) { |c| age(c.birthdate) }
    column :grade_level
    column :parent_pickup
    column :needs_bed
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
      row(:gender) { |c| gender_name(c.gender) }
      row :birthdate
      row('Age', sortable: :birthdate) { |c| age(c.birthdate) }
      row :grade_level
      row :childcare_weeks
      row :parent_pickup
      row :needs_bed
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
      f.input :family
      f.input :gender, as: :select, collection: gender_select
      f.input :birthdate, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :grade_level
      f.input :parent_pickup
      f.input :needs_bed
      f.input :childcare_weeks, label: 'Weeks of ChildCare', collection: Childcare::CHILDCARE_WEEKS, multiple: true, hint: "Please add all weeks needed"
      
    end
    f.inputs "Assign ChildCare Spaces" do
      f.input :childcare_id, as: :select, collection: Childcare.all.order(:title).map {|c| ["#{c.title} | #{c.teachers} | #{c.address} | size:#{c.children.size}", c.id]}, label: 'Childcare Spaces', prompt: "please select"
    end

    f.actions
  end
end
