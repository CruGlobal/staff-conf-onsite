ActiveAdmin.register Attendee do
  include Attendees::Show
  include Attendees::Form

  remove_filter :family # Adds N+1 additional quries to the index page

  menu parent: 'People', priority: 2

  permit_params(
    :first_name, :last_name, :email, :emergency_contact, :phone, :staff_number,
    :student_number, :gender, :department, :family_id, :birthdate, :ministry_id,
    conference_ids: [], course_ids: [], meal_exemptions_attributes: [
      :id, :_destroy, :date, :meal_type
    ]
  )

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
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def scoped_collection
      super.includes(:family)
    end
  end
end
