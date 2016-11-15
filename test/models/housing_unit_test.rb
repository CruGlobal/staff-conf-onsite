require 'test_helper'

class HousingUnitTest < ActiveSupport::TestCase
  setup do
    create_users
    @housing_unit = create :housing_unit
  end

  test 'permit create' do
    assert_permit @general_user, @housing_unit, :create
    assert_permit @finance_user, @housing_unit, :create
    assert_permit @admin_user, @housing_unit, :create
  end

  test 'permit read' do
    assert_permit @general_user, @housing_unit, :show
    assert_permit @finance_user, @housing_unit, :show
    assert_permit @admin_user, @housing_unit, :show
  end

  test 'permit update' do
    assert_permit @general_user, @housing_unit, :update
    assert_permit @finance_user, @housing_unit, :update
    assert_permit @admin_user, @housing_unit, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @housing_unit, :destroy
    assert_permit @finance_user, @housing_unit, :destroy
    assert_permit @admin_user, @housing_unit, :destroy
  end
end
