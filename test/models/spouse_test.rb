require 'test_helper'

class SpouseTest < ActiveSupport::TestCase
  setup do
    create_users
    @spouse = create :spouse
  end

  test 'permit create' do
    assert_permit @general_user, @spouse, :create
    assert_permit @finance_user, @spouse, :create
    assert_permit @admin_user, @spouse, :create
  end

  test 'permit read' do
    assert_permit @general_user, @spouse, :show
    assert_permit @finance_user, @spouse, :show
    assert_permit @admin_user, @spouse, :show
  end

  test 'permit update' do
    assert_permit @general_user, @spouse, :update
    assert_permit @finance_user, @spouse, :update
    assert_permit @admin_user, @spouse, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @spouse, :destroy
    assert_permit @finance_user, @spouse, :destroy
    assert_permit @admin_user, @spouse, :destroy
  end
end
