class ChargePersonRecPassCost
  include Interactor::Organizer

  organize SumPersonRecPassCost,
           ApplyCostAdjustments
end
