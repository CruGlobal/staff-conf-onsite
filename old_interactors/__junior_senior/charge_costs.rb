class JuniorSenior::ChargeCosts
  include Interactor::Organizer

  organize JuniorSenior::SumCosts,
           ApplyCostAdjustments
end
