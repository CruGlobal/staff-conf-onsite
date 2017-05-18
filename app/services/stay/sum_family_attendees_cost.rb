# == Context Input
#
# [+context.family+ [+Family+]]
# [+context.housing_type+ [+#to_s+]]
#   An optional {Stay#housing_type} to filter by
class Stay::SumFamilyAttendeesCost < ChargesService
  attr_accessor :family, :housing_type

  def call
    family_costs.each do |cost|
      self.total_adjustments += cost.total_adjustments
      self.subtotal += cost.subtotal
      self.total += cost.total
    end
  end

  private

  def family_costs
    family.attendees.map do |attendee|
      Stay::ChargeAttendeeCost.call(attendee: attendee,
                                    housing_type: housing_type)
    end
  end
end
