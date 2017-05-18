class Conference::ChargePersonCost < ChargesService
  attr_accessor :person

  def call
    sum = Conference::SumPersonCost.call(person: person)

    assign_totals(
      ApplyCostAdjustments.call(charges: sum.charges,
                                cost_adjustments: sum.cost_adjustments)
    )
  end
end
