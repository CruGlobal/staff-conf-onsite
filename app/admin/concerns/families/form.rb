module Families
  module Form
    def self.included(base)
      base.send :form, title: ->(f) { "Edit #{PersonHelper.family_label(f)}" } do |f|
        f.semantic_errors

        instance_exec(f, &BasicInfoFields)
        instance_exec(f, &AddressFields)
        instance_exec(f, &HousingPreferencesFields)

        f.actions
      end
    end

    BasicInfoFields = proc do |f|
      f.inputs 'Basic Info' do
        f.input :last_name
        f.input :staff_number
      end
    end

    AddressFields = proc do |f|
      f.inputs 'Address' do
        f.input :street
        f.input :city
        f.input :state
        f.input :country_code, as: :select, collection: country_select,
                               include_blank: false
        f.input :zip
      end
    end

    HousingPreferencesFields = proc do |f|
      for_housing_preference = [
        :housing_preference,
        f.object.housing_preference || f.object.build_housing_preference
      ]

      f.inputs 'Housing Preference', class: 'housing_preference_attributes',
                                     for: for_housing_preference do |hp|
        hp.input :housing_type, as: :select, collection: housing_type_select

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

        hp.input :confirmed_at, as: :datepicker
      end
    end
  end
end
