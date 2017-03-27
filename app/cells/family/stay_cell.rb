class Family::StayCell < ::ShowCell
  property :family

  def attendees_costs_panel
    panel 'Attendees Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      cell('cost_adjustment/summary',
           self, result: SumFamilyAttendeesStayCost.call(family: family)).call
    end
  end

  def children_costs_panel
    panel 'Children Housing Costs (Temporary panel for demo)', class: 'TODO_panel' do
      cell('cost_adjustment/summary',
           self, result: SumFamilyChildrenStayCost.call(family: family)).call
    end
  end
end
