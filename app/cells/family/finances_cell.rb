class Family::FinancesCell < ::ShowCell
  COSTS = {
    'Conferences' => Conference::SumFamilyCost,
    'Rec Pass' => RecPass::SumFamilyCost,
    'Childcare' => Childcare::SumFamilyCost,
    'Hot Lunches' => HotLunch::SumFamilyCost,
    'Attendee Housing' => Stay::SumFamilyAttendeesCost,
    'Children Housing' => Stay::SumFamilyChildrenCost
  }.freeze

  property :family

  def show
    panel 'Finances', class: 'finances_panel' do
      cell('cost_adjustment/summary_table', self, results: cost_results).call
    end
  end

  private

  def cost_results
    Hash[
      COSTS.map { |name, service| [name, service.call(family: family)] }
    ]
  end
end
