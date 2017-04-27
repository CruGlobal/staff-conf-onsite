class JuniorSenior::SumCosts < BaseChildcareSumCosts
  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  protected

  def age_group
    :junior_senior
  end
end
