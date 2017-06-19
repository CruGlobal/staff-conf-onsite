class FacilityUseFee::SumAttendeeCost < ChargesService
  attr_accessor :attendee

  def call
    charges[:facility_use] += facility_use_fees
    self.cost_adjustments = attendee.cost_adjustments
  end

  def facility_use_fees
    return 0 if attendee.exempt?

    facility_use_fees = part1 + part2
    facility_use_fees.negative? ? 0 : facility_use_fees
  end

  private

  # We start charging a Facility Use Fee on the first day of your stay in
  # official housing.
  # If you're not using Cru provided housing, we use whatever you put as your
  # arrival date when registering online.
  # If your start date is before facility_use_start, we use that value instead.
  def start_date
    @start_date ||=
      begin
        apt_arrived_at = attendee.stays.in_apartment.minimum(:arrived_at)

        arrived = apt_arrived_at || attendee.arrived_at&.in_time_zone
        arrived = nil if arrived && arrived < UserVariable[:facility_use_start]

        arrived || UserVariable[:facility_use_start]
      end
  end

  # The last day we charge FUF is either the day before you said you're
  # leaving, or the facility_use_end variable, whichever is sooner.
  def end_date
    @end_date ||=
      begin
        depart = attendee.departed_at&.in_time_zone
        depart -= 1.day if depart

        if start_date && (!depart || depart > UserVariable[:facility_use_end])
          depart = nil
        end

        depart || UserVariable[:facility_use_end]
      end
  end

  def part1
    start_date && start_date < split_date ? part1_cost : Money.empty
  end

  def part1_cost
    diff = (part1_end_date - start_date).to_i
    part1 = Money.us_dollar(diff * UserVariable[:facility_use_before])

    # Subtract out dorm stays
    days =
      in_dorm_scope.
        where('arrived_at < ?', part1_end_date).
        inject(0) { |sum, stay| sum + part1_days(stay) }

    part1 - (days * UserVariable[:facility_use_before])
  end

  def part1_end_date
    end_date > split_date ? split_date : end_date
  end

  def part1_days(stay)
    end_at = [stay.departed_at, part1_end_date].min
    start_at = [stay.arrived_at, UserVariable[:facility_use_start]].max

    (end_at.in_time_zone - start_at.in_time_zone).to_i
  end

  def part2
    end_date && end_date >= split_date ? part2_cost : Money.empty
  end

  def part2_cost
    # The reason for the +1 in the code below is that the charge needs to
    # account for start -> end date *inclusive*. When you subtract start from
    # end, it effectively doesn't count the last day.
    diff = (end_date - part2_start_date + 1).to_i
    part2 = Money.us_dollar(diff * UserVariable[:facility_use_after])

    # Subtrack out dorm stays
    days =
      in_dorm_scope.
        where('departed_at > ?', part2_start_date).
        inject(0) { |sum, stay| sum + part2_days(stay) }

    part2 - days * UserVariable[:facility_use_after]
  end

  def part2_start_date
    start_date < split_date ? split_date : start_date
  end

  def part2_days(stay)
    start_at = [stay.arrived_at, part2_start_date].max
    end_at = [UserVariable[:facility_use_end], stay.departed_at].min

    (end_at.in_time_zone - start_at.in_time_zone).to_i + 1
  end

  def in_dorm_scope
    @in_dorm_scope ||= attendee.stays.in_dormitory
  end

  def split_date
    UserVariable[:facility_use_split]
  end

  def off_campus?
    type = attendee.family.housing_preference.housing_type
    %w(apartment self_provided).include?(type)
  end
end
