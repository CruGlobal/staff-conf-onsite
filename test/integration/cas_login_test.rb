require 'test_helper'

class CasLoginTest < IntegrationTest
  # Need to add Okta login test
  # test 'Login Page' do
  #   visit root_path

  #   assert_current_path root_path
  #   assert_title 'Fake CAS'
  # end

  test 'login' do
    user = create_login_user

    visit dashboard_path
    assert_title 'Dashboard'
  end
end
