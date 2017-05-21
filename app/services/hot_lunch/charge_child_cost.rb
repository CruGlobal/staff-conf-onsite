class HotLunch::ChargeChildCost < ChargesService
  attr_accessor :child

  def call
    sum = HotLunch::SumChildCost.call(child: child)

    assign_totals(
      ApplyCostAdjustments.call(charges: sum.charges,
                                cost_adjustments: sum.cost_adjustments)
    )
  end
end