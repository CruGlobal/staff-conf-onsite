ActiveAdmin.register Child do
  menu parent: 'People', priority: 3

  # permit_params :first_name, :last_name, :birthdate, :gender, :family, :parent_pickup, :needs_bed, childcare_weeks: []

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
      f.input :parent_pickup
      f.input :needs_bed
      f.input :childcare_weeks, label: 'Weeks of ChildCare', collection: Childcare::CHILDCARE_WEEKS, multiple: true, hint: "Hold control or command to select more than one week."
    end
    f.inputs "ChildCare Spaces" do
      
      # f.input :childcare_weeks, as: :checkboxes, collection: childcare_weeks_select, multiple: true, hint: 'Hold Command/Shift to select multiple.', label: 'Childcare Weeks'
      # f.collection_check_boxes :childcare_weeks, childcare_weeks_select, :id, :name do |m|
      #   m.check_box
      #   m.label
      # end
      # f.input :childcare_weeks, label: 'Weeks of ChildCare', collection: Childcare::CHILDCARE_WEEKS, multiple: true, hint: "Hold control or command to select more than one week."
      f.input :childcare_id, as: :select, collection: Childcare.all.order(:title).map {|c| ["#{c.title} | #{c.teachers} | #{c.address} | size:#{c.children.size}", c.id]}, label: 'Childcare Spaces', prompt: "please select"
    end

    f.actions
  end
  controller do
    def permitted_params
      params.permit!
    end
  end
end
