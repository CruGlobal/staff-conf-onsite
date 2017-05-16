# == Context Input
#
# [+context.child+ [+Child+]]
class HotLunch::SumChildCost
  include Interactor

  AGE_RANGE = 3..4

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.charges[:lunch] +=
      if applicable?
        hot_lunch_costs.inject(Money.empty, :+)
      else
        Money.empty
      end

    context.cost_adjustments = context.child.cost_adjustments
  end

  private

  def applicable?
    AGE_RANGE.include?(context.child.age)
  end

  def hot_lunch_costs
    hot_lunch_in_dorm_indexes.map do |index|
      UserVariable["hot_lunch_week_#{index}"]
    end
  end

  # @see Childcare#CHILDCARE_WEEKS
  def hot_lunch_in_dorm_indexes
    hot_lunch_start_dates.
      map { |index, date| index unless in_dorm_at?(date) }.
      compact
  end

  # @return [Hash<Integer,Date>]
  def hot_lunch_start_dates
    Hash[
      context.child.hot_lunch_weeks.map do |week_offset|
        [week_offset, UserVariable[:childcare_first_day] + week_offset.weeks]
      end
    ]
  end

  def in_dorm_at?(date)
    context.child.stays.for_date(date).any?(&:dormitory?)
  end
end
