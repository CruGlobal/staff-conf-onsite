module CostAdjustmentHelper
  I18N_PREFIX = 'activerecord.attributes.cost_adjustment'.freeze

  module_function

  def cost_type_select
    CostAdjustment.cost_types.map do |type, value|
      [cost_type_name(value), type]
    end
  end

  # @param [ApplicationRecord, Fixnum] obj - either a record with a
  #   {cost_type} field, or the ordinal value of the
  #   {CostAdjustment#cost_type} enum
  # @return [String] the translated name of that type
  def cost_type_name(obj)
    # typecast an integer into an enum string
    type =
      case obj
      when ApplicationRecord
        obj.cost_type
      when Fixnum
        CostAdjustment.new(cost_type: obj).cost_type
      when nil
        nil
      else
        raise "unexpected parameter, '#{obj.inspect}'"
      end

    I18n.t("#{I18N_PREFIX}.cost_types.#{type}")
  end
end
