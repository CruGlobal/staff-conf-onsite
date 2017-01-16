ActiveAdmin.register Child do
  include Children::Show
  include Children::Form

  menu parent: 'People', priority: 3

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params :first_name, :last_name, :birthdate, :gender, :family_id,
                :parent_pickup, :needs_bed, :grade_level, :childcare_id,
                childcare_weeks: [],
                cost_adjustments_attributes: [:id, :_destroy, :description, :person_id,
                                              :price, :cost_type],
                meal_exemptions_attributes: [:id, :_destroy, :date,
                                             :meal_type],
                stays_attributes: [:id, :_destroy, :housing_unit_id,
                                   :arrived_at, :departed_at,
                                   :single_occupancy, :no_charge,
                                   :waive_minimum, :percentage, :comment]

  index do
    selectable_column
    column :id
    column :first_name
    column :last_name
    column(:family) { |c| link_to family_label(c.family), family_path(c.family) }
    column(:gender) { |c| gender_name(c.gender) }
    column :birthdate
    column(:age, sortable: :birthdate) { |c| age(c) }
    column(:grade_level) { |c| grade_level_label(c) }
    column :parent_pickup
    column :needs_bed
    column :created_at
    column :updated_at
    actions
  end
end
