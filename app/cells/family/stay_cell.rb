class Family::StayCell < ::ShowCell
  property :family

  def attendees_costs_panel
    panel 'Attendees Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = SumFamilyAttendeesStayCost.call(family: family)
      if result.success?
        temporary_stay_cost_table(result)
      else
        div(class: 'flash flash_error') { result.error }
      end
    end
  end

  def children_costs_panel
    panel 'Children Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      result = SumFamilyChildrenStayCost.call(family: family)
      if result.success?
        temporary_stay_cost_table(result)
      else
        div(class: 'flash flash_error') { result.error }
      end
    end
  end

  def temporary_stay_cost_table(result)
    table do
      temporary_stay_cost_table_head
      tr do
        td { humanized_money_with_symbol result.subtotal }
        td { humanized_money_with_symbol result.total_adjustments * -1 }
        td { humanized_money_with_symbol result.total }
      end
    end
  end

  def temporary_stay_cost_table_head
    tr do
      th { 'Sub-Total' }
      th { 'Adjustments' }
      th { 'Total' }
    end
  end
end
