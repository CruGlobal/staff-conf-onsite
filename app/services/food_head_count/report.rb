# The resulting table of Daily Food Head Counts. Each element is a sub-table of
# {FoodHeadCount::CafeteriaDate} for that date. Each +CafeteriaDate+ contains
# the various meal counts for a single date/cafeteria pair.
#
# @example
#   2017-01-02:
#     'McDonalds':
#       adult_breakfast: 15
#       adult_lunch:      0
#       adult_dinner:     8
#     'Burger King':
#       teen_breakfast:   0
#       teen_dinner:      2
#       child_breakfast: 11
class FoodHeadCount::Report < ApplicationService
  # An optional start date. If missing, the {Stay#arrived_at} of the oldest
  # dorm stay will be used
  attr_accessor :start_at

  # An optional end date. If missing, the {Stay#departed_at} of the most-recent
  # dorm stay will be used
  attr_accessor :end_at

  def call
    date_range.each do |date|
      head_count = sum_date_cost(date).head_count
      head_counts.add(head_count) unless head_count.zero?
    end
  end

  def head_counts
    @head_counts ||= FoodHeadCount::Table.new
  end

  private

  def date_range
    return 0...0 if stay_date_scope.empty?

    (start_at || Date.today)..(end_at || stay_date_scope.max_date)
  end

  def stay_date_scope
    @stay_date_scope ||= Stay.in_dormitory
  end

  def sum_date_cost(date)
    FoodHeadCount::SumDateCost.call(date: date)
  end
end
