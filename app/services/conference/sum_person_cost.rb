# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class Conference::SumPersonCost < ChargesService
  attr_accessor :person

  def call
    charges[:tuition_track] +=
      # TODO: exclude staff conference once it's added
      person.conferences.
        map(&:price).
        inject(Money.empty, &:+)

    self.cost_adjustments = person.cost_adjustments
  end
end
