ActiveAdmin.register MealExemption do
  permit_params :person_id, :date, :meal_type

  belongs_to :attendee

  index title: -> { "#{@attendee.full_name}: Meal Exemptions" }
  show title: ->(m) { "#{m.attendee.full_name}: #{m.date.to_s(:long_ordinal)} #{m.meal_type} Meal Exemption" }

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :person
      datepicker_input(f, :date)
      f.input :meal_type, as: :select, collection: meal_type_select
    end

    f.actions
  end

  filter :person
  filter :date
  filter :meal_type, as: :select, collection: MealExemptionHelper.meal_type_select
  filter :created_at
  filter :updated_at

  sidebar 'Attendee' do
    h4 strong link_to(attendee.full_name, attendee_path(attendee))
  end
end
