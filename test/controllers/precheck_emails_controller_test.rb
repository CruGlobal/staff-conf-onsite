require 'test_helper'

class PrecheckEmailsControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  test 'new action without an auth param gets error page' do
    get :new
    assert_response :success
    assert_template :error
  end

  test 'new action with an invalid auth token gets error page' do
    get :new, auth_token: "sdfsdf"
    assert_response :success
    assert_template :error
  end

  test 'new action with a valid auth token' do
    token = create(:precheck_email_token)
    get :new, auth_token: token.token

    assert_response :success
    assert_template :new
    assigns(:family)
  end
end
