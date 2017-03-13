# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class SumAttendeeStayCost
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  # If the housing facility for this individual assignment is an apartment,
  # look for the "DO NO CHARGE FOR THIS ASSIGNMENT" flag - if YES, the charge =
  # $0, and quit.
  #
  # For ALL dorm housing assignments (in case there's more than one), add up
  # the TOTAL number of days living in a DORM (only). Call this the TOTAL Dorm
  # Days.
  #
  # For each individual adult housing assignment:
  #   1) Calculate length of stay in # days for this individual assignment:
  #      arrival date minus departure date (result must be greater than 0)
  #
  #   2) Using Housing Facility from the assignment, determine the Cost Code.
  #
  #   3) If the housing facility is an APARTMENT, check to see if "WAIVE
  #      MINIMUM STAY" is checked. If so, go to step 4. If MINIMUM STAY for this
  #      housing facility is > length of stay, length of stay = MINIMUM STAY
  #
  #   4) Using the Cost Code, look up Adult $?/Day daily cost. A cost code may
  #      have multiple cost "groups". The correct cost group will be determined
  #      by choosing the group where the smallest Maximum Stay is >= either
  #      (the apartment individual length of stay) or (the TOTAL Dorm Days).
  #
  #   5) If the housing facility for this individual assignment is a DORM, if
  #      the "Single Occupancy" is YES, look up the "SINGLE UPCHARGE $/DAY" for
  #      this length of stay (for an apartment type, the "SINGLE UPCHARGE
  #      $/DAY" will always be $0).
  #
  #   6) Total cost is: individual length of stay X (daily cost + daily
  #      upcharge)
  #
  #   7) If the housing facility for this individual assignment is an
  #      apartment, multiply the total cost by the %COST THE OCCUPANT MUST PAY

  # The final output is the resulting dollar amount.
  def call
    context.attendee.stays.each(&method(:sum_stay_cost))

    context.cost_adjustments = context.attendee.cost_adjustments
  end

  private

  def sum_stay_cost(stay)
    return if stay.housing_type == 'self_provided'

    daily_cost = sum_daily_cost(stay)
    if (type = charge_type(stay))
      context.charges[type] += must_pay(stay, daily_cost * stay.duration)
    else
      fail_no_charge_type!(stay)
    end
  end

  def sum_daily_cost(stay)
    cost_code = stay.housing_facility.try(:cost_code)

    if (charge = cost_code.try(:charge, days: stay.duration))
      if stay.housing_type == 'dormitory' && stay.single_occupancy?
        charge.adult + charge.single_delta
      else
        charge.adult
      end
    else
      fail_no_cost_code!(stay)
    end
  end

  def fail_no_cost_code!(stay)
    context.fail!(
      error: format('%p does not have an associated cost code which can be ' \
                    'applied to a stay of %d days',
                    (stay.housing_facility || stay), stay.duration)
    )
  end

  def charge_type(stay)
    case stay.housing_type
    when 'apartment' then 'apartment_rent'
    when 'dormitory' then 'dorm_adult'
    end
  end

  def fail_no_charge_type!(stay)
    context.fail!(
      error: format('%p has an unknown facility type: "%s"',
                    (stay.housing_facility || stay), stay.housing_type)
    )
  end

  def must_pay(stay, cost)
    cost * (stay.housing_type == 'apartment' ? stay.must_pay_ratio : 1)
  end
end
