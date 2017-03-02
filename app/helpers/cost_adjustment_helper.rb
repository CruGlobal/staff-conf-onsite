module CostAdjustmentHelper
  I18N_PREFIX_COST_ADJUSTMENT = 'activerecord.attributes.cost_adjustment'.freeze

  # @return [Array<[label, id]>] a map of {CostAdjustment} IDs and their
  #   descriptions
  def cost_type_select
    CostAdjustment.cost_types.map do |type, value|
      [cost_type_name(value), type]
    end
  end

  # @param obj [ApplicationRecord, Fixnum] either a record with a +cost_type+
  #   field, or the ordinal value of the +CostAdjustment#cost_type+ enum
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

    I18n.t("#{I18N_PREFIX_COST_ADJUSTMENT}.cost_types.#{type}")
  end

  def cost_adjustment_amount(cost_adjustment)
    if cost_adjustment.percent.present?
      "#{cost_adjustment.percent}%"
    else
      humanized_money_with_symbol(cost_adjustment.price)
    end
  end
end
