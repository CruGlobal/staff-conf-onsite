class Childcare::SumCosts < BaseChildcareSumCosts
  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  protected

  def age_group
    :childcare
  end
end
