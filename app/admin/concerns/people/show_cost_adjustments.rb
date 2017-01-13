module People
  module ShowCostAdjustments
    COST_ADJUSTMENTS_PANEL ||= proc do |person|
      panel "Cost Adjustments (#{person.cost_adjustments.size})" do
        if person.cost_adjustments.any?
          ul do
            person.cost_adjustments.each do |ca|
              li do
                link_to("#{humanized_money_with_symbol(ca.price)} - #{cost_type_name(ca)}", ca)
              end
            end
          end
        else
          strong 'None'
        end
      end
    end
  end
end
