class RecPass::ChargePersonCost
  include Interactor::Organizer

  organize RecPass::SumPersonCost,
           ApplyCostAdjustments
end
