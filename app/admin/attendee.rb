ActiveAdmin.register Attendee do
  include Attendees::Show
  include Attendees::Form

  remove_filter :family # Adds N+1 additional quries to the index page

  menu parent: 'People', priority: 2

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params(
    :first_name, :last_name, :email, :emergency_contact, :phone,
    :student_number, :gender, :department, :family_id, :birthdate, :ministry_id,
    conference_ids: [], course_ids: [], meal_exemptions_attributes: [
      :id, :_destroy, :date, :meal_type
    ], stays_attributes: [
      :id, :_destroy, :housing_unit_id, :arrived_at, :departed_at,
      :single_occupancy, :no_charge, :waive_minimum, :percentage
    ]
  )

  index do
    selectable_column
    column :id
    column(:student_number) { |a| code a.student_number }
    column :first_name
    column :last_name
    column(:family) { |a| link_to family_label(a.family), family_path(a.family) }
    column :birthdate
    column('Age', sortable: :birthdate) { |a| age(a.birthdate) }
    column(:gender) { |a| gender_name(a.gender) }
    column(:email) { |a| mail_to(a.email) }
    column(:phone) { |a| format_phone(a.phone) }
    column :emergency_contact
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
