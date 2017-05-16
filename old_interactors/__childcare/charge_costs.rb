class Childcare::ChargeCosts
  include Interactor::Organizer

  organize Childcare::SumCosts,
           ApplyCostAdjustments
end
