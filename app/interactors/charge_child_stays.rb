class ChargeChildStays
  include Interactor::Organizer

  organize SumChildStayCost,
           ApplyCostAdjustments
end
