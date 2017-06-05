class StaffConference::SumAttendeeCost < ChargesService
  attr_accessor :attendee

  def call
    charges[:tuition_staff] += conferences_price
    self.cost_adjustments = attendee.cost_adjustments
  end

  private

  def conferences_price
    non_staff_conferences.map(&:price).inject(Money.empty, &:+)
  end

  def non_staff_conferences
    attendee.conferences.select(&:staff_conference?)
  end
end
