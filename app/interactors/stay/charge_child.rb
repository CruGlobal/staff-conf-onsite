class Stay::ChargeChild
  include Interactor::Organizer

  organize Stay::SumChildCost,
           ApplyCostAdjustments
end
