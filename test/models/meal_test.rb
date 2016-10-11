require 'test_helper'

class MealTest < ActiveSupport::TestCase
  setup do
    create_users
    @meal = create :meal
  end

  test 'permit create' do
    assert_permit @general_user, @meal, :create
    assert_permit @finance_user, @meal, :create
    assert_permit @admin_user, @meal, :create
  end

  test 'permit read' do
    assert_permit @general_user, @meal, :show
    assert_permit @finance_user, @meal, :show
    assert_permit @admin_user, @meal, :show
  end

  test 'permit update' do
    assert_permit @general_user, @meal, :update
    assert_permit @finance_user, @meal, :update
    assert_permit @admin_user, @meal, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @meal, :destroy
    assert_permit @finance_user, @meal, :destroy
    assert_permit @admin_user, @meal, :destroy
  end

  test 'order_by_date when empty' do
    hash = Meal.where('1 == 0').order_by_date
    assert_empty hash
  end

  test 'order_by_date' do
    attendee = create :attendee

    breakfast, lunch, dinner = Meal::TYPES

    date1 = Date.parse('2016-01-01')
    date2 = Date.parse('2016-07-22')
    date3 = Date.parse('2016-09-11')
    dateUnused = Date.parse('2999-12-31')

    attendee.meals.create(date: date1, meal_type: breakfast)
    attendee.meals.create(date: date1, meal_type: lunch)
    attendee.meals.create(date: date1, meal_type: dinner)

    attendee.meals.create(date: date2, meal_type: dinner)

    attendee.meals.create(date: date3, meal_type: breakfast)
    attendee.meals.create(date: date3, meal_type: dinner)

    hash = attendee.meals.order_by_date

    assert_equal 3, hash.keys.size
    assert_equal 3, hash[date1].size
    assert_equal 1, hash[date2].size
    assert_equal 2, hash[date3].size
    assert_empty hash[dateUnused]

    assert_kind_of Meal, hash[date1][breakfast]
    assert_kind_of Meal, hash[date1][lunch]
    assert_kind_of Meal, hash[date1][dinner]

    assert_kind_of Meal, hash[date2][dinner]

    assert_kind_of Meal, hash[date3][breakfast]
    assert_kind_of Meal, hash[date3][dinner]
  end
end
