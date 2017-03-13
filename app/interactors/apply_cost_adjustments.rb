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
# [+context.subtotal+ [+Money+]]
#   The total of all charges, before the {CostAdjustment cost adjustments} are
#   applied
# [+context.total+ [+Money+]]
#   The total of all charges, after the {CostAdjustment cost adjustments} are
#   applied
class ApplyCostAdjustments
  include Interactor

  def call
    context.subtotal ||= Money.empty
    context.total ||= Money.empty

    context.charges.each(&method(:add_total))
  end

  private

  def add_total(type, sum)
    adjustments = context.cost_adjustments.select { |c| c.cost_type == type }

    context.subtotal += sum
    context.total += [Money.empty, apply_discounts(sum, adjustments)].max
  end

  def apply_discounts(sum, adjustments)
    new_sum = sum - sum * total_percent(adjustments)
    new_sum - (prices(adjustments).inject(:+) || Money.empty)
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
end
