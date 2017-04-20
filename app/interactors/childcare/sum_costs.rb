# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class Childcare::SumCosts
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.charges[:childcare_jr_sr] += each_charge.inject(Money.empty, :+)
    context.charges[:childcare_jr_sr] += deposit_charge

    context.cost_adjustments = context.child.cost_adjustments
  end

  private

  def each_charge
    context.child.childcare_weeks.map { |index| charge(index) }
  end

  def charge(index)
    UserVariable[:"childcare_week_#{index}"]
  end

  def deposit_charge
    if context.child.childcare_deposit?
      UserVariable[:childcare_deposit]
    else
      Money.empty
    end
  end
end
