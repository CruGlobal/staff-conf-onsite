class HotLunch::SumFamilyCampCost < ChargesService
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
    care_levels = Child.childcare_care_grade_levels
    family.children.map do |c|
      if c.childcare_camp_grade? && !care_levels.include?(c.grade_level)
        HotLunch::ChargeChildCost.call(child: c)
      end
    end.compact
  end
end
