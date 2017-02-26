class Family::FormCell < ::FormCell
  def show
    show_errors_if_any

    basic_info_fields
    address_fields
    housing_preference_fields

    actions
  end

  private

  def basic_info_fields
    inputs 'Basic Info' do
      input :last_name
      input :staff_number
    end
  end

  def address_fields
    inputs 'Address' do
      input :street
      input :city
      input :state
      input :country_code, as: :select, collection: country_select,
                           include_blank: false
      input :zip
    end
  end

  def housing_preference_fields
    if object.new_record?
      object.build_housing_preference(housing_type: :self_provided)
    end

    inputs 'Housing Preference', class: 'housing_preference_attributes' do
      semantic_fields_for :housing_preference do |hp|
        hp.input :housing_type, as: :select, collection: housing_type_select,
                                include_blank: false

        dynamic_preference_inputs(hp)
        datepicker_input(hp, :confirmed_at)
      end

      input :registration_comment, as: :ckeditor
    end
  end

  def dynamic_preference_inputs(hp)
    dynamic_preference_input(hp, :roommates, input_html: { rows: 4 })
    dynamic_preference_input(hp, :beds_count)
    dynamic_preference_input(hp, :single_room)

    dynamic_preference_input(hp, :children_count)
    dynamic_preference_input(hp, :bedrooms_count)
    dynamic_preference_input(hp, :other_family)
    dynamic_preference_input(hp, :accepts_non_air_conditioned)

    dynamic_preference_input(hp, :location1)
    dynamic_preference_input(hp, :location2)
    dynamic_preference_input(hp, :location3)
  end
end
