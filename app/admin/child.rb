ActiveAdmin.register Child do
  page_cells do |page|
    page.index
    page.show
    page.form(Person::FormCell::OPTIONS)
  end

  menu parent: 'People', priority: 3

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params(
    :first_name, :last_name, :birthdate, :gender, :family_id, :parent_pickup,
    :needs_bed, :grade_level, :childcare_id, :arrived_at, :departed_at,
    :childcare_deposit, :childcare_comment, :rec_center_pass_started_at,
    :rec_center_pass_expired_at,
    childcare_weeks: [], hot_lunch_weeks: [],
    cost_adjustments_attributes: [
      :id, :_destroy, :description, :person_id, :price, :percent, :cost_type
    ],
    meal_exemptions_attributes: [
      :id, :_destroy, :date, :meal_type
    ],
    stays_attributes: [
      :id, :_destroy, :housing_unit_id, :arrived_at, :departed_at,
      :single_occupancy, :no_charge, :waive_minimum, :percentage, :comment
    ]
  )

  filter :first_name
  filter :last_name
  filter :birthdate
  filter :gender
  filter :parent_pickup
  filter :needs_bed
  filter :arrived_at
  filter :departed_at
  filter :childcare_class

  action_item :import_spreadsheet, only: :index do
    link_to 'Import Spreadsheet', new_spreadsheet_families_path
  end
end
