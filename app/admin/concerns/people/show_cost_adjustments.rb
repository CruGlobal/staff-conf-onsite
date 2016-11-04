module People
  module ShowCostAdjustments
    CostAdjustmentsPanel = proc do |person|
      panel "Cost Adjustments (#{person.cost_adjustments.size})" do
        if person.cost_adjustments.any?
          ul do
            person.cost_adjustments.each do |p|
              li { link_to(humanized_money_with_symbol(p.price), p) }
            end
          end
        else
          strong 'None'
        end
      end
    end
  end
end
