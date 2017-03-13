class ChargeAttendeeStays
  include Interactor::Organizer

  organize SumAttendeeStayCost,
           ApplyCostAdjustments
end
