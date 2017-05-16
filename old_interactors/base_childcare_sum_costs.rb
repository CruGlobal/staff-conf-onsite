# == Context Input
#
# [+context.child+ [+Child+]]
class BaseChildcareSumCosts
  extend Forwardable
  include Interactor

  def_delegator :context, :child

  def call
    context.charges[age_group] += each_charge.inject(Money.empty, :+)
    context.charges[age_group] += deposit_charge

    context.cost_adjustments = child.cost_adjustments
  end

  protected

  def age_group
    raise NotImplementedError
  end

  private

  def each_charge
    child.childcare_weeks.map { |index| charge(index) }
  end

  def charge(index)
    UserVariable[age_group_symbol("week_#{index}")]
  end

  def age_group_symbol(suffix)
    format('%s_%s', age_group, suffix).to_sym
  end

  def deposit_charge
    if child.childcare_deposit?
      UserVariable[:childcare_deposit]
    else
      Money.empty
    end
  end
end
