class ChargeConferenceCosts
  include Interactor::Organizer

  organize SumConferenceCosts,
           ApplyCostAdjustments
end
