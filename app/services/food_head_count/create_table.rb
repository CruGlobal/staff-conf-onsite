class FoodHeadCount::CreateTable < ApplicationService
  # An optional cafeteria by which to filter the count
  attr_accessor :cafeteria

  # An optional start date. If missing, the {Stay#arrived_at} of the oldest
  # dorm stay will be used
  attr_accessor :start_at

  # An optional end date. If missing, the {Stay#departed_at} of the most-recent
  # dorm stay will be used
  attr_accessor :end_at

  # The resulting table of Daily Food Head Counts. Each key is a date and each
  # value is a sub-table of "cafeteria head-counts" for that date.
  #
  # In the cafeteria head-counts sub-titles, each key is the name of the
  # cafeteria and each value is a map of "meal types" to the number of meals of
  # that type, for that cafeteria, for that day.
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
  attr_reader :table

  def call
    @table ||= Hash[
      date_range.map { |date| [date, sum_date_cost(date).counts] }
    ]
  end

  private

  def date_range
    return 0...0 if stay_date_scope.empty?

    (start_at || stay_date_scope.min_date)..(end_at || stay_date_scope.max_date)
  end

  def stay_date_scope
    @stay_date_scope ||= Stay.in_dormitory
  end

  def sum_date_cost(date)
    FoodHeadCount::SumDateCost.call(date: date, cafeteria: cafeteria)
  end
end
