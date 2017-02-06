module HousingHelper
  I18N_PREFIX_HOUSING = 'activerecord.attributes.housing_facility'.freeze

  module_function

  # @param type [HousingFacility, #to_s] either a facility record or the value
  #   of its +housing_type+ fields
  # @return [String] a string describing the given type
  def housing_type_label(type)
    type = type.housing_type if type.is_a?(HousingFacility)
    I18n.t("activerecord.attributes.housing_facility.housing_types.#{type}")
  end

  # @return [Array<[label, id]>] the {HousingFacility housing types} +<select>+
  #   options acceptable for +options_for_select+
  def housing_type_select
    HousingFacility.housing_types.map do |type, value|
      [housing_type_name(value), type]
    end
  end

  # @param obj [ApplicationRecord, Fixnum] either a record with a
  #   +housing_type+ field, or the ordinal value of the +housing_type+ enum
  # @return [String] the translated name of that type
  def housing_type_name(obj)
    # typecast an integer into an enum string
    type =
      case obj
      when ApplicationRecord
        obj.housing_type
      when Fixnum
        HousingFacility.new(housing_type: obj).housing_type
      else
        raise "unexpected parameter, '#{obj.inspect}'"
      end

    I18n.t("#{I18N_PREFIX_HOUSING}.housing_types.#{type}")
  end

  # Creates an input element, used by the JavaScript code in
  # +app/assets/javascripts/family/edit.coffee+ to dynamically show/hide this
  # HTML element.
  #
  # @see .dynamic_attribute_input
  def dynamic_preference_input(form, attribute, opts = {})
    dynamic_attribute_input(
      HousingPreference::HOUSING_TYPE_FIELDS, form, attribute, opts
    )
  end

  # Creates an input element, used by the JavaScript code in
  # +app/assets/javascripts/stay/dynamic_fields.coffee+ to dynamically
  # show/hide this HTML element.
  #
  # @see .dynamic_attribute_input
  def dynamic_stay_input(form, attribute, opts = {})
    dynamic_attribute_input(Stay::HOUSING_TYPE_FIELDS, form, attribute, opts)
  end

  # Creates input fields that can by dynamically shown/hidden whenver the user
  # changes the value of particular select box, controlled by JavaScript.
  def dynamic_attribute_input(attributes_map, form, attribute, opts = {})
    classes = attributes_map[attribute].map { |t| "for-#{t}" }.join(' ')

    opts[:wrapper_html] ||= {}
    opts[:wrapper_html][:class] = "dynamic-field #{classes}"

    form.input(attribute, opts)
  end

  # Creates a select element, used by the JavaScript code in
  # +app/assets/javascripts/housing/select_housing_unit.coffee+ to allow the
  # user to select a {Person peron's} housing assingment from a convenient UI
  # widget.
  #
  # @param form [Formtastic::FormBuilder]
  # @param attribute_name [Symbol] the name of the attribute to populate
  def select_housing_unit_widget(form, attribute_name = :housing_unit)
    form.input(
      attribute_name,
      as: :select,
      collection: HousingUnit.all.map { |u| [u.name, u.id] },
      input_html: {
        'data-housing_unit-id' => true,
        'data-labels' => Hash[HousingUnit.all.map { |u| [u.id, u.name] }].to_json,
        'data-hierarchy' => housing_unit_hierarchy.to_json
      }
    )
  end

  # A helper method that generates the Housing
  # Type-{HousingFacility}-{HousingUnit} hierarchy used by the JavaScript
  # select widget.
  # @see .select_housing_unit_widget
  def housing_unit_hierarchy
    hierarchy ||= HousingUnit.hierarchy

    {}.tap do |h|
      h[housing_type_label(:self_provided)] ||= {}

      hierarchy.each do |type, facilities|
        h[type] ||= {}
        facilities.each do |facility, units|
          h[type][facility.name] ||= units.order(:name).map(&:id)
        end
      end
    end
  end
end
