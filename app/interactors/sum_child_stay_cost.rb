class SumChildStayCost
  include Interactor

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
  #
  # 6) Subtract from that grand total charge any Child Dorm cost adjustments.
  #    These could be either a percentage reduction or a fixed amount reduction.
  #    The grand total cannot be less than $0.
  def call
    context.dorms = dorm_stays
    context.charges = dorm_stays.map { |stay| stay_charge(stay) }

    total_charge = apply_adjustments(context.charges.inject(:+))
    context.total_charge = [0, total_charge].max
  end

  private

  # @note This method also updates +context.total_charge+
  def stay_charge(stay)
    days = stay.duration
    cost_code = stay.housing_facility.try(:cost_code)

    if (charge = cost_code.try(:charge, days: days))
      daily_costs = daily_costs(context.child, charge, stay.single_occupancy)
      daily_costs.inject(:+) * days
    else
      context.fail!(
        error: format('%p does not have an associated cost code which can be ' \
                      'applied to a stay of %d days',
                      (stay.housing_facility || stay), days)
      )
    end
  end

  def dorm_stays
    context.child.stays.select { |s| s.housing_type == 'dormitory' }
  end

  def daily_costs(child, charge, single)
    result = ListChildCosts.call(child: child, single_occupancy: single)
    result.costs.map { |cost| charge.send(cost) }
  end

  def dorm_cost_adjustments
    context.child.cost_adjustments.
      select { |ca| ca.cost_type == 'dorm_child' }.
      map(&:price)
  end

  def apply_adjustments(cost)
    cost ||= Money.new(0)

    ApplyCostAdjustments.call(
      cost: cost,
      cost_adjustments: context.child.cost_adjustments
    ).new_cost
  end
end
