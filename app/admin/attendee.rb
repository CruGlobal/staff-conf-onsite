ActiveAdmin.register Attendee do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  remove_filter :family # Adds N+1 additional quries to the index page

  menu parent: 'People', priority: 2

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params(
    :first_name, :last_name, :email, :emergency_contact, :phone, :gender,
    :student_number, :department, :family_id, :birthdate, :ministry_id,
    :arrived_at, :departed_at, conference_ids: [], cost_adjustments_attributes: [
      :id, :_destroy, :description, :person_id, :price, :cost_type
    ], course_attendances_attributes: [
      :id, :_destroy, :course_id, :seminary_credit, :grade
    ], meal_exemptions_attributes: [
      :id, :_destroy, :date, :meal_type
    ], stays_attributes: [
      :id, :_destroy, :housing_unit_id, :arrived_at, :departed_at,
      :single_occupancy, :no_charge, :waive_minimum, :percentage, :comment
    ]
  )

  filter :student_number
  filter :first_name
  filter :last_name
  filter :birthdate
  filter :gender
  filter :email
  filter :phone
  filter :emergency_contact
  filter :department
  filter :ministry
  filter :courses
  filter :arrived_at
  filter :departed_at
  filter :created_at
  filter :updated_at

  controller do
    def scoped_collection
      super.includes(:family)
    end
  end
end
