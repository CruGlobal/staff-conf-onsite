ActiveAdmin.register Child do
  include Children::Show
  include Children::Form

  menu parent: 'People', priority: 3

  permit_params(
    :first_name, :last_name, :birthdate, :gender, :family, :parent_pickup,
    :needs_bed, :grade_level, childcare_weeks: [], meal_exemptions_attributes: [
      :id, :_destroy, :date, :meal_type
    ]
  )

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
end
