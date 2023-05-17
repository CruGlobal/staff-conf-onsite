require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::StatusControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  stub_user_variable conference_id: 'MyConfName',
                     support_email: 'support@example.org',
                     conference_logo_url: 'https://www.logo.com',
                     mail_interceptor_email_addresses: ['test@test.com']

  test 'show action with an invalid auth token gets error page' do
    get :show, params: { token: "sdfsdf" }
    assert_response :success
    assert_template :error
  end

  test 'show action with a valid auth token' do
    family = create(:family)
    get :show, params: { token: family.precheck_email_token.token }

    assert_response :success
    assert_template :show
    assigns(:family)
  end
end
