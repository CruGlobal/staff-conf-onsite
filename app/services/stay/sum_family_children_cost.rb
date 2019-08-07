class Stay::SumFamilyChildrenCost < ChargesService
  attr_accessor :family

  # +Money+
  #   The taxable total of all charges, after the {CostAdjustment cost adjustments} are
  #   applied
  attr_accessor :taxable_total

  # +Money+
  #   The non taxable total of all charges, after the {CostAdjustment cost adjustments} are
  #   applied
  attr_accessor :nontaxable_total

  def call
    family_costs.each do |cost|
      self.total_adjustments += cost.total_adjustments
      self.subtotal += cost.subtotal
      self.total += cost.total
      if cost.child.childcare_weeks.present? && cost.child.age_group == :junior_senior
        self.nontaxable_total += cost.total
      else
        self.taxable_total += cost.total
      end
    end
  end

  private

  def family_costs
    family.children.map { |c| Stay::ChargeChildCost.call(child: c) }
  end

  def default_values
    super

    self.taxable_total ||= Money.empty
    self.nontaxable_total ||= Money.empty
  end
end
