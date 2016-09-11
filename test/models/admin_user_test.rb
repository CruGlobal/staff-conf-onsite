require 'test_helper'

class AdminUserTest < ActiveSupport::TestCase
  test 'admin predicate' do
    general = create :general_user
    admin = create :admin_user

    refute general.admin?
    assert admin.admin?
  end
end
