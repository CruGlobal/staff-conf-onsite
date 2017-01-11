module Families
  # Defines the form for creating and editong {Family} records.
  module Form
    def self.included(base)
      title = lambda do |f|
        f.new_record? ? 'New Family' : "Edit #{PersonHelper.family_label(f)}"
      end

      base.send :form, title: title do |f|
        f.semantic_errors

        instance_exec(f, &BASIC_INFO_FIELDS)
        instance_exec(f, &ADDRESS_FIELDS)
        instance_exec(f, &HOUSING_PREFERENCE_FIELDS)

        f.inputs do
          f.input :registration_comment, as: :ckeditor
        end

        f.actions
      end
    end

    BASIC_INFO_FIELDS ||= proc do |f|
      f.inputs 'Basic Info' do
        f.input :last_name
        f.input :staff_number
      end
    end

    ADDRESS_FIELDS ||= proc do |f|
      f.inputs 'Address' do
        f.input :street
        f.input :city
        f.input :state
        f.input :country_code, as: :select, collection: country_select,
                               include_blank: false
        f.input :zip
      end
    end

    HOUSING_PREFERENCE_FIELDS ||= proc do |f|
      if f.object.new_record?
        f.object.build_housing_preference(housing_type: :self_provided)
      end

      f.inputs 'Housing Preference', class: 'housing_preference_attributes' do
        f.semantic_fields_for :housing_preference do |hp|
          hp.input :housing_type, as: :select, collection: housing_type_select,
                                  include_blank: false

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

          datepicker_input(hp, :confirmed_at)
        end
      end
    end
  end
end
