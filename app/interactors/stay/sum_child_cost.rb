# == Context Input
#
# [+context.child+ [+Child+]]
class Stay::SumChildCost
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.charges[:dorm_child] +=
      dorm_stays.map { |stay| stay_charge(stay) }.inject(Money.empty, &:+)
    context.cost_adjustments = context.child.cost_adjustments
  end

  private

  def stay_charge(stay)
    result = Stay::SingleChildDormitoryCost.call(child: context.child,
                                                 stay: stay)

    if result.success?
      result.total
    else
      context.fail!(error: context.error)
      Money.empty
    end
  end

  def dorm_stays
    context.child.stays.select { |s| s.housing_type == 'dormitory' }
  end
end
