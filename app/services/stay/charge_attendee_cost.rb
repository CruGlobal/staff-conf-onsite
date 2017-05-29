# == Context Input
#
# [+context.attendee+ [+Attendee+]]
# [+context.housing_type+ [+#to_s+]]
#   An optional {Stay#housing_type} to filter by
class Stay::ChargeAttendeeCost < ChargesService
  attr_accessor :attendee, :housing_type

  def call
    assign_totals(
      ApplyCostAdjustments.call(charges: sum.charges,
                                cost_adjustments: sum.cost_adjustments)
    )
  end

  def sum
    @sum ||= Stay::SumAttendeeCost.call(attendee: attendee,
                                        housing_type: housing_type)
  end
end
