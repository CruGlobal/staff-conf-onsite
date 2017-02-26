ActiveAdmin.register Child do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  menu parent: 'People', priority: 3

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params(
    :first_name, :last_name, :birthdate, :gender, :family_id, :parent_pickup,
    :needs_bed, :grade_level, :childcare_id, :arrived_at, :departed_at,
    childcare_weeks: [],
    cost_adjustments_attributes: [
      :id, :_destroy, :description, :person_id, :price, :cost_type
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
end
