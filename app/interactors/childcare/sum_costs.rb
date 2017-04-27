# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class Childcare::SumCosts
  extend Forwardable
  include Interactor

  def_delegator :context, :child

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.charges[:childcare_jr_sr] += each_charge.inject(Money.empty, :+)
    context.charges[:childcare_jr_sr] += deposit_charge

    context.cost_adjustments = child.cost_adjustments
  end

  private

  def each_charge
    child.childcare_weeks.map { |index| charge(index) }
  end

  def charge(index)
    UserVariable[age_group_symbol("week_#{index}")]
  end

  def age_group_symbol(suffix)
    format('%s_%s', age_group_prefix, suffix).to_sym
  end

  def age_group_prefix
    child.age_group == :childcare ? :childcare : :junior_senior
  end

  def deposit_charge
    if child.childcare_deposit?
      UserVariable[:childcare_deposit]
    else
      Money.empty
    end
  end
end
