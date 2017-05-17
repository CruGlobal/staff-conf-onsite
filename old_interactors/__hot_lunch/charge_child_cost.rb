class HotLunch::ChargeChildCost
  include Interactor::Organizer

  organize HotLunch::SumChildCost,
           ApplyCostAdjustments
end
