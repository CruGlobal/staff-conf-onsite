class Conference::ChargeCosts
  include Interactor::Organizer

  organize Conference::SumCosts,
           ApplyCostAdjustments
end
