class ChargeChildHotLunchCost
  include Interactor::Organizer

  organize SumChildHotLunchCost,
           ApplyCostAdjustments
end
