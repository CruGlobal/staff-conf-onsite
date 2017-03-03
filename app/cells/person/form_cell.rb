class Person::FormCell < ::FormCell
  FORM_OPTIONS ||= {
    # If creating a new family-member, show the family name in the title
    title: proc do |person|
      label = "#{action_name.titlecase} #{person.class.name}"

      if (family = person.family || param_family)
        "#{label} (#{family_label(family)})"
      else
        label
      end
    end
  }.freeze

  # If creating a new family-member, do not let the family association be
  # editable.
  def family_selector
    if (id = object.family_id || param_family.try(:id))
      input :family_id, as: :hidden, input_html: { value: id }
    else
      input :family
    end
  end

  def stay_subform
    collection = [:stays, object.stays.order(:arrived_at)]

    panel 'Housing Assignments', class: 'housing_assignments',
                                 'data-housing_unit-container' => true do
      has_many :stays, heading: nil, for: collection do |f|
        select_housing_unit_widget(f)

        datepicker_input(f, :arrived_at)
        datepicker_input(f, :departed_at)

        dynamic_stay_input(f, :percentage)
        dynamic_stay_input(f, :single_occupancy)
        dynamic_stay_input(f, :no_charge)
        dynamic_stay_input(f, :waive_minimum)

        f.input :comment, as: :ckeditor
        f.input :_destroy, as: :boolean, wrapper_html: { class: 'destroy' }
      end
    end
  end

  def cost_adjustment_subform
    panel 'Cost Adjustments', class: 'cost_adjustments',
                              'data-housing_unit-container' => true do
      has_many :cost_adjustments, heading: nil do |f|
        f.input :cost_type, as: :select, collection: cost_type_select
        money_input_widget(f, :price)
        f.input :percent
        f.input :description, as: :ckeditor
      end
    end
  end

  private

  def person
    @options.fetch(:person)
  end
end
