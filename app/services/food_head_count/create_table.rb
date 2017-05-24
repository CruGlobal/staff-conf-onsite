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
class FoodHeadCount::CreateTable < ApplicationService
  # An optional cafeteria by which to filter the count
  attr_accessor :cafeteria

  # An optional start date. If missing, the {Stay#arrived_at} of the oldest
  # dorm stay will be used
  attr_accessor :start_at

  # An optional end date. If missing, the {Stay#departed_at} of the most-recent
  # dorm stay will be used
  attr_accessor :end_at

  def call
    cafes = cafeteria.present? ? [cafeteria] : HousingFacility.cafeterias

    date_range.each do |date|
      cafes.each { |c| head_counts.add(sum_date_cost(date, c).head_count) }
    end
  end

  def head_counts
    @head_counts ||= FoodHeadCount::Table.new
  end

  private

  def date_range
    return 0...0 if stay_date_scope.empty?

    (start_at || stay_date_scope.min_date)..(end_at || stay_date_scope.max_date)
  end

  def stay_date_scope
    @stay_date_scope ||=
      if cafeteria.present?
        Stay.in_dormitory.with_cafeteria(cafeteria)
      else
        Stay.in_dormitory
      end
  end

  def sum_date_cost(date, cafe)
    FoodHeadCount::SumDateCost.call(date: date, cafeteria: cafe)
  end
end
