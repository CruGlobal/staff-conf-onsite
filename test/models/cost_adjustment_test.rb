require 'test_helper'

class CostAdjustmentTest < ActiveSupport::TestCase
  setup do
    create_users
    @cost_adjustment = create :cost_adjustment
  end

  test 'cents=' do
    @cost_adjustment.update(cents: 100)
    assert_equal 100, @cost_adjustment.cents

    @cost_adjustment.update(cents: '100')
    assert_equal 100, @cost_adjustment.cents

    @cost_adjustment.update(cents: '$USD 1.00')
    assert_equal 100, @cost_adjustment.cents

    @cost_adjustment.update(cents: '$USD 0.00')
    assert_equal 0, @cost_adjustment.cents

    @cost_adjustment.update(cents: '$USD 123.45')
    assert_equal 12345, @cost_adjustment.cents

    @cost_adjustment.update(cents: '1,234,567.89')
    assert_equal 123456789, @cost_adjustment.cents
  end

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
