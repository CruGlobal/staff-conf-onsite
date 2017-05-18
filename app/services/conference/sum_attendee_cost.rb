# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class Conference::SumAttendeeCost < ChargesService
  attr_accessor :attendee

  def call
    charges[:tuition_track] +=
      # TODO: exclude staff conference once it's added
      attendee.conferences.
        map(&:price).
        inject(Money.empty, &:+)

    self.cost_adjustments = person.cost_adjustments
  end
end
