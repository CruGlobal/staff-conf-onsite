require 'test_helper'

class MinistryTest < ActiveSupport::TestCase
  setup do
    create_users
    @ministry = create :ministry
  end

  test 'permit create' do
    assert_permit @general_user, @ministry, :create
    assert_permit @finance_user, @ministry, :create
    assert_permit @admin_user, @ministry, :create
  end

  test 'permit read' do
    assert_permit @general_user, @ministry, :show
    assert_permit @finance_user, @ministry, :show
    assert_permit @admin_user, @ministry, :show
  end

  test 'permit update' do
    assert_permit @general_user, @ministry, :update
    assert_permit @finance_user, @ministry, :update
    assert_permit @admin_user, @ministry, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @ministry, :destroy
    assert_permit @finance_user, @ministry, :destroy
    assert_permit @admin_user, @ministry, :destroy
  end
end
