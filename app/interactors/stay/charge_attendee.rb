class Stay::ChargeAttendee
  include Interactor::Organizer

  organize Stay::SumAttendeeCost,
           ApplyCostAdjustments
end
