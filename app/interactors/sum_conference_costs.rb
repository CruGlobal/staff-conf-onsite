# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class SumConferenceCosts
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.charges[:tuition_track] +=
      # TODO: exclude staff conference once it's added
      context.attendee.conferences.
        map(&:price).
        inject(Money.empty, &:+)

    context.cost_adjustments = context.attendee.cost_adjustments
  end
end
