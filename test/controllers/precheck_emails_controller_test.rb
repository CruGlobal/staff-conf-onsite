require 'test_helper'

class PrecheckEmailsControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  stub_user_variable conference_id: 'MyConfName',
                     support_email: 'support@example.org',
                     conference_logo_url: 'https://www.logo.com'

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

  test 'reject action without an auth param gets error page' do
    post :reject
    assert_response :success
    assert_template :error
  end

  test 'reject action with an invalid auth token get error page' do
    post :reject, auth_token: "sdfsdf"
    assert_response :success
    assert_template :error
  end

  test 'reject action with a valid token sends change request email and deletes token' do
    token = create(:precheck_email_token)

    assert_difference('PrecheckEmailToken.count', -1) do
      assert_emails 1 do
        post :reject, auth_token: token.token, message: "My name is misspelled"
      end
    end

    assigns(:family)
    last_email = ActionMailer::Base.deliveries.last
    assert_equal "MyConfName - Precheck Modification Request", last_email.subject
    assert_redirected_to precheck_email_rejected_path
  end

  test 'confirm action without an auth param gets error page' do
    post :confirm
    assert_response :success
    assert_template :error
  end

  test 'confirm action with an invalid auth token get error page' do
    post :confirm, auth_token: "sdfsdf"
    assert_response :success
    assert_template :error
  end

  test 'confirm action with a valid token checks in family, sends precheck confirmed email and deletes token' do
    token = create(:precheck_email_token)

    assert_difference('PrecheckEmailToken.count', -1) do
      assert_emails 1 do
        post :confirm, auth_token: token.token
      end
    end

    assigns(:family)
    last_email = ActionMailer::Base.deliveries.last
    assert_equal "MyConfName - Precheck Completed", last_email.subject
    assert_redirected_to precheck_email_confirmed_path
  end
end
