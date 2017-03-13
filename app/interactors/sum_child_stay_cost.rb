# == Context Input
#
# [+context.child+ [+Child+]]
class SumChildStayCost
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  # First, for ALL dorm housing assignments (in case there's more than one),
  # add up the TOTAL number of days living in a dorm. Call this the TOTAL Days.
  #
  # For each individual child dorm housing assignment:
  #
  # 1) Calculate length of say in # days for this individual assignment:
  #    arrival date minus departure date (result must be greater than 0).
  #
  # 2) Using dorm, look up daily cost in cost code table for the TOTAL Days
  #    length of stay using the following age breakdown:
  #    Use "ADULT $/DAY" column if child's age is >=15 years old
  #    Use "TEEN $/DAY" column if child's age is >=11 <15 years old
  #    Use "CHILD $/DAY" column if (child's age is >= 5 < 11 years old AND "Needs Bed" = YES)
  #    Use "INFANT $/DAY" column if (child's age is <5 years old AND "Needs Bed" = YES)
  #    Use "CHILD MEAL ONLY $/DAY" if (child'd age is <11 and "Needs Bed" = NO)
  #
  # 3) If the "Single Occupancy" is YES, look up the "SINGLE UPCHARGE $/DAY"
  #    for this length of stay
  #
  # 4) Total cost is: individual length of stay multiplied by (daily cost +
  #    daily upcharge)
  #
  # 5) Loop through if there are multiple child dorm assignments
  def call
    context.charges['dorm_child'] +=
      dorm_stays.map { |stay| stay_charge(stay) }.inject(Money.empty, &:+)
    context.cost_adjustments = context.child.cost_adjustments
  end

  private

  def stay_charge(stay)
    days = stay.duration
    cost_code = stay.housing_facility.try(:cost_code)

    if (charge = cost_code.try(:charge, days: days))
      daily_costs = daily_costs(context.child, charge, stay.single_occupancy)
      daily_costs.inject(:+) * days
    else
      fail_no_cost_code!(stay, days)
    end
  end

  def dorm_stays
    context.child.stays.select { |s| s.housing_type == 'dormitory' }
  end

  def daily_costs(child, charge, single)
    result = ListChildCosts.call(child: child, single_occupancy: single)
    result.costs.map { |cost| charge.send(cost) }
  end

  def fail_no_cost_code!(stay, days)
    context.fail!(
      error: format('%p does not have an associated cost code which can be ' \
                    'applied to a stay of %d days',
                    (stay.housing_facility || stay), days)
    )
  end
end
