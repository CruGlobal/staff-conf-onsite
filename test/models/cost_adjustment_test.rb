require 'test_helper'

class CostAdjustmentTest < ActiveSupport::TestCase
  setup do
    create_users
    @cost_adjustment = create :cost_adjustment
  end

  test_money_attr(:conference, :price)

  test 'permit create' do
    refute_permit @general_user, @cost_adjustment, :create

    assert_permit @finance_user, @cost_adjustment, :create
    assert_permit @admin_user, @cost_adjustment, :create
  end

  test 'permit read' do
    assert_permit @general_user, @cost_adjustment, :show
    assert_permit @finance_user, @cost_adjustment, :show
    assert_permit @admin_user, @cost_adjustment, :show
  end

  test 'permit update' do
    refute_permit @general_user, @cost_adjustment, :update

    assert_permit @finance_user, @cost_adjustment, :update
    assert_permit @admin_user, @cost_adjustment, :update
  end

  test 'permit destroy' do
    refute_permit @general_user, @cost_adjustment, :destroy

    assert_permit @finance_user, @cost_adjustment, :destroy
    assert_permit @admin_user, @cost_adjustment, :destroy
  end
end
