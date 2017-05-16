# == Context Input
#
# [+context.attendee+ [+Attendee+]]
# [+context.housing_type+ [+#to_s+]]
#   An optional {Stay#housing_type} to filter by
class Stay::ChargeAttendee
  include Interactor::Organizer

  organize Stay::SumAttendeeCost,
           ApplyCostAdjustments
end
