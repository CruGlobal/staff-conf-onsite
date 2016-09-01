ActiveAdmin.register Attendee do
  menu parent: 'People', priority: 1

  permit_params :first_name, :last_name, :email, :emergency_contact, :phone,
                :birthdate, :student_number, :staff_number, :gender, :department

  index do
    selectable_column
    column :id
    column(:student_number) { |a| h4 a.staff_number }
    column :first_name
    column(:last_name) do |a|
      link_to a.last_name, family_path(a.family) if a.family_id
    end
    column :birthdate
    column('Age', sortable: :birthdate) { |a| age(a.birthdate) }
    column(:gender) { |a| gender_name(a.gender) }
    column(:email) { |a| mail_to(a.email) }
    column(:phone) { |a| format_phone(a.phone) }
    column :emergency_contact
    column :staff_number
    column :department
    column 'Meals' do |a|
      link_to a.meals.count, attendee_meals_path(a)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row(:staff_number) { |a| code a.staff_number }
      row :first_name
      row(:last_name) do |a|
        link_to a.last_name, family_path(a.family) if a.family_id
      end
      row :birthdate
      row('Age', sortable: :birthdate) { |a| age(a.birthdate) }
      row(:gender) { |a| gender_name(a.gender) }
      row(:email) { |a| mail_to(a.email) }
      row(:phone) { |a| format_phone(a.phone) }
      row :emergency_contact
      row :staff_number
      row :department
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors

    f.inputs 'Basic' do
      f.input :student_number
      f.input :first_name
      f.input :last_name
      f.input :gender, as: :select, collection: gender_select
      f.input :birthdate, as: :datepicker, datepicker_options: { changeYear: true, changeMonth: true }
      f.input :family
    end

    f.inputs 'Contact' do
      f.input :email
      f.input :phone
      f.input :emergency_contact
    end

    f.inputs do
      f.input :ministry
      f.input :staff_number
      f.input :department
    end
  end
end
