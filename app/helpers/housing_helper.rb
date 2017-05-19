module HousingHelper
  I18N_PREFIX_HOUSING = 'activerecord.attributes.housing_facility'.freeze

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
          when Integer
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
  def select_housing_unit_widget(context)
    @select_housing_unit_widget ||= context.instance_exec do
      ul(style: 'display:none', class: 'housing_unit_list') do
        housing_unit_hierarchy.each do |type, facilities|
          if facilities.present?
            li('data-dropdown-text' => type) do
              ul do
                facilities.each do |facility_name, unit_ids|
                  li('data-dropdown-text' => facility_name) do
                    ul do
                      unit_ids.each do |id|
                        li housing_labels[id]
                      end
                    end
                  end
                end
              end
            end
          else
            li type
          end
        end
      end
    end

  end

  def housing_labels
    @housing_labels ||= Hash[housing_units.map { |u| [u.id, u.name] }]
  end

  # A helper method that generates the Housing
  # Type-{HousingFacility}-{HousingUnit} hierarchy used by the JavaScript
  # select widget.
  # @see .select_housing_unit_widget
  def housing_unit_hierarchy
    @hierarchy ||= HousingUnit.hierarchy

    {}.tap do |h|
      h[housing_type_label('self_provided')] ||= {}

      @hierarchy.each do |type, facilities|
        h[type] ||= {}
        facilities.each do |facility, units|
          next if units.empty?
          h[type][facility.name] ||= units.natural_order_asc.map(&:id)
        end
      end
    end
  end

  # @return [Array] All the housing units sorted by natural_order
  def housing_units
    @housing_units ||= HousingUnit.all.natural_order_asc
  end

  # @return [String] a short phrase describing how long the Stay will last
  def join_stay_dates(stay)
    dates =
        [:arrived_at, :departed_at].map do |attr|
          simple_format_attr(stay, attr)
        end
    dates.join(' until ')
  end
end
