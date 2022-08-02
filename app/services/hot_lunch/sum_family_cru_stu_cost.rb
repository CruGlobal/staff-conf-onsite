class HotLunch::SumFamilyCruStuCost < ChargesService
  attr_accessor :family

  def call
    family_costs.each do |cost|
      self.total_adjustments += defined?(cost.total_adjustments) ? cost.total_adjustments : Money.empty
      self.subtotal += defined?(cost.subtotal) ? cost.subtotal : Money.empty
      self.total += defined?(cost.total) ? cost.total : Money.empty
    end
  end

  private

  def family_costs
    family.children.map { |c| HotLunch::ChargeChildCost.call(child: c) if c.crustu_grade?}
  end
end
