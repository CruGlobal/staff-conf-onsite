require 'test_helper'

class ChildTest < ActiveSupport::TestCase
  setup do
    create_users
    @child = create :child
  end

  test 'permit create' do
    assert_permit @general_user, @child, :create
    assert_permit @finance_user, @child, :create
    assert_permit @admin_user, @child, :create
  end

  test 'permit read' do
    assert_permit @general_user, @child, :show
    assert_permit @finance_user, @child, :show
    assert_permit @admin_user, @child, :show
  end

  test 'permit update' do
    assert_permit @general_user, @child, :update
    assert_permit @finance_user, @child, :update
    assert_permit @admin_user, @child, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @child, :destroy
    assert_permit @finance_user, @child, :destroy
    assert_permit @admin_user, @child, :destroy
  end
end
