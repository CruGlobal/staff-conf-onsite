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
    assert_equal "Cru19 Precheck Modification Request", last_email.subject
    assert_redirected_to precheck_email_rejected_path
  end
end
