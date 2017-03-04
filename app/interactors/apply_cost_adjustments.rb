# Apply a series of {CostAdjustment cost adjustments} to a given amount of
# {Money money}.
#
# The adjustments are applied in this order:
#
#   1. The percent-based adjustments are summed and subtracted from the given
#      cost. ex: $100 - ($100 * (5% + 10% + 10%)) = $75
#   2. The price-based adjustments are then summed and subtracted from that
#      result. ex: $75 - ($10 + $5) = $60
#
# [+context.cost+ [+Money+]]
# [+context.cost_adjustments+ [+Array<CostAdjustment>+]]
#   if the person has opted to take an entire dormitory room for themselves
class ApplyCostAdjustments
  include Interactor

  def call
    context.new_cost = apply_discounts(context.cost)
  end

  private

  def apply_discounts(cost)
    new_cost = cost - cost * total_percent_adjustment
    new_cost - (price_adjustments.inject(:+) || 0)
  end

  def price_adjustments
    context.cost_adjustments.select(&:price_cents?).map(&:price)
  end

  def total_percent_adjustment
    (percent_adjustments.inject(:+) || 0) / 100.0
  end

  def percent_adjustments
    context.cost_adjustments.select(&:percent?).map(&:percent)
  end
end
