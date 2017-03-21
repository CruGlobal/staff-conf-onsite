# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class SumAttendeeStayCost
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.attendee.stays.each(&method(:sum_stay_cost))

    context.cost_adjustments = context.attendee.cost_adjustments
  end

  private

  def sum_stay_cost(stay)
    result = SingleAttendeeStayCost.call(stay: stay)

    if result.success?
      context.charges[result.type] += result.total
    else
      context.fail!(error: context.error)
      Money.empty
    end
  end
end
