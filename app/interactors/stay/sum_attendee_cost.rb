# == Context Input
#
# [+context.attendee+ [+Attendee+]]
# [+context.housing_type+ [+#to_s+]]
#   An optional {Stay#housing_type} to filter by
class Stay::SumAttendeeCost
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    stays.each(&method(:sum_stay_cost))

    context.cost_adjustments = context.attendee.cost_adjustments
  end

  private

  def stays
    if context.housing_type.present?
      context.attendee.stays.select do |s|
        s.housing_type == context.housing_type
      end
    else
      context.attendee.stays
    end
  end

  def sum_stay_cost(stay)
    result = Stay::SingleAttendeeCost.call(stay: stay)

    if result.success?
      context.charges[result.type] += result.total
    else
      context.fail!(error: context.error)
      Money.empty
    end
  end
end
