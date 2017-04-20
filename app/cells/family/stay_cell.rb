class Family::StayCell < ::ShowCell
  property :family

  def attendees_costs_panel
    panel 'Attendees Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      cell('cost_adjustment/summary',
           self, result: Stay::SumFamilyAttendeesCost.call(family: family)).call
    end
  end

  def children_costs_panel
    panel 'Children Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      cell('cost_adjustment/summary',
           self, result: Stay::SumFamilyChildrenCost.call(family: family)).call
    end
  end
end
