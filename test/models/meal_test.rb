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
end
