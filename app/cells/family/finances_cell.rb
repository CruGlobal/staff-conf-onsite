class Family::FinancesCell < ::ShowCell
  property :family

  def show
    panel 'Finances', class: 'finances_panel' do
      cell('cost_adjustment/summary_table', self, results: cost_results).call
    end
  end

  private

  def cost_results
    @results ||= {
      'Conferences' => Conference::SumFamilyCost.call(family: family),
      'Rec Pass' => RecPass::SumFamilyCost.call(family: family),
      'Childcare' => Childcare::SumFamilyCost.call(family: family),
      'Junior/Senior' => JuniorSenior::SumFamilyCost.call(family: family),
      'Hot Lunches' => HotLunch::SumFamilyCost.call(family: family),
      'Adult Apartment Housing' => Stay::SumFamilyAttendeesApartmentCost.call(family: family),
      'Adult Dormitory Housing' => Stay::SumFamilyAttendeesDormitoryCost.call(family: family),
      'Children Housing' => Stay::SumFamilyChildrenCost.call(family: family)
    }
  end
end
