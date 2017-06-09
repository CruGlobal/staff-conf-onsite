class FacilityUseFee::SumAttendeeCost < ChargesService
  attr_accessor :attendee

  def call
    charges[:facility_use] += facility_use_fees
    self.cost_adjustments = attendee.cost_adjustments
  end

  def facility_use_fees
    facility_use_fees = part1 + part2
    facility_use_fees.negative? ? 0 : facility_use_fees
  end

  private

  # We start charging a Facility Use Fee on the first day of your stay in official housing.
  # If you're not using Cru provided housing, we use whatever you put as your arrival date
  # when registering online.
  # If your start date is before facility_use_start, we use that value instead.
  def start_date
    unless @start_date
      @start_date = attendee.stays.in_apartment.minimum(:arrived_at)
      @start_date ||= attendee.arrived_at
      if @start_date && @start_date < UserVariable[:facility_use_start]
        @start_date = UserVariable[:facility_use_start]
      end
    end
    @start_date ||= UserVariable[:facility_use_start]
  end

  # The last day we charge FUF is either the day before you said you're leaving, or the facility_use_end variable,
  # whichever is sooner.
  def end_date
    unless @end_date
      departure = attendee.departed_at
      @end_date = departure - 1.day if departure
      if @start_date && (!@end_date || @end_date > UserVariable[:facility_use_end])
        @end_date = UserVariable[:facility_use_end]
      end
    end
    @end_date ||= UserVariable[:facility_use_end]
  end

  def part1
    if start_date && start_date < split_date
      part1 = Money.us_dollar((split_date - start_date).to_i * UserVariable[:facility_use_before])
      # Subtract out dorm stays
      attendee.stays.in_dormitory.where('arrived_at < ?', split_date).each do |stay|
        days = ([stay.departed_at, split_date].min - [stay.arrived_at, UserVariable[:facility_use_start]].max).to_i
        part1 -= days * UserVariable[:facility_use_before]
      end
      part1
    else
      Money.empty
    end
  end

  def part2
    if end_date && end_date >= split_date
      # The reason for the +1 in the code below is that the charge needs to account for start -> end date *inclusive*
      # When you subtract start from end, it effectively doesn't count the last day.
      part2 = Money.us_dollar((end_date - split_date + 1).to_i * UserVariable[:facility_use_after])
      # Subtrack out dorm stays
      attendee.stays.in_dormitory.where('departed_at > ?', split_date).each do |stay|
        days = ([UserVariable[:facility_use_end], stay.departed_at].min - [stay.arrived_at, split_date].max).to_i + 1
        part2 -= days * UserVariable[:facility_use_after]
      end
      part2
    else
      Money.empty
    end
  end

  def split_date
    UserVariable[:facility_use_split]
  end

  def off_campus?
    %w(apartment self_provided).include?(attendee.family.housing_preference.housing_type)
  end
end
