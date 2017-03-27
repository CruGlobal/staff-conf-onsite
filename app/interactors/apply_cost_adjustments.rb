# Apply a series of {CostAdjustment cost adjustments} to one or more costs.
#
# The adjustments are applied in this order:
#
#   1. The percent-based adjustments are summed and subtracted from the given
#      cost. ex: $100 - ($100 * (5% + 10% + 10%)) = $75
#   2. The price-based adjustments are then summed and subtracted from that
#      result. ex: $75 - ($10 + $5) = $60
#
# == Context Input
#
# [+context.charges+ [+Hash<String, Money>+]]
#   Each key is one of {CostAdjustment#cost_types} and each value is the total
#   cost in that category. The types are used to determine which adjustments
#   apply to each charge
# [+context.cost_adjustments+ [+Array<CostAdjustment>+]]
#
# == Context Output
#
# [+context.total_adjustments+ [+Money+]]
#   The total dollar-amount of all adjustments
# [+context.subtotal+ [+Money+]]
#   The total of all charges, before the {CostAdjustment cost adjustments} are
#   applied
# [+context.total+ [+Money+]]
#   The total of all charges, after the {CostAdjustment cost adjustments} are
#   applied
class ApplyCostAdjustments
  include Interactor

  before do
    context.total_adjustments ||= Money.empty
    context.subtotal ||= Money.empty
    context.total ||= Money.empty
  end

  def call
    context.charges.each(&method(:add_total))
    constrain_total_adjustments
  end

  private

  def add_total(type, sum)
    type = type.to_s
    adjustments = context.cost_adjustments.select { |c| c.cost_type == type }
    add_to_context(sum, realize_adjustments(sum, adjustments))
  end

  def add_to_context(sum, adjust)
    context.total_adjustments += adjust
    context.subtotal += sum
    context.total += [Money.empty, sum - adjust].max
  end

  def realize_adjustments(sum, adjustments)
    percent_reduction = sum * total_percent(adjustments)
    percent_reduction + prices(adjustments).inject(Money.empty, &:+)
  end

  def total_percent(adjustments)
    (percents(adjustments).inject(:+) || 0) / 100.0
  end

  def percents(adjustments)
    adjustments.select(&:percent?).map(&:percent)
  end

  def prices(adjustments)
    adjustments.select(&:price_cents?).map(&:price)
  end

  def constrain_total_adjustments
    if context.total_adjustments > context.subtotal
      context.total_adjustments = context.subtotal
    end
  end
end
