module HousingHelper
  I18N_PREFIX = 'activerecord.attributes.housing_facility'.freeze

  module_function

  def housing_type_select
    HousingFacility::housing_types.map do |type, value|
      [housing_type_name(value), type]
    end
  end

  # @param [ApplicationRecord, Fixnum] obj - either a record with a
  #   {housing_type} field, or the ordinal value of the
  #   {HousingFacility#housing_type} enum
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
        fail "unexpected parameter, '#{obj.inspect}'"
      end

    I18n.t("#{I18N_PREFIX}.housing_types.#{type}")
  end
end

