require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::ConfirmationControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  stub_user_variable conference_id: 'MyConfName',
                     support_email: 'support@example.org',
                     conference_logo_url: 'https://www.logo.com',
                     mail_interceptor_email_addresses: ['test@test.com']

  test '#create with an invalid auth token get error page' do
    post :create, token: "sdfsdf"
    assert_response :success
    assert_template :error
  end

  test '#create with a valid token checks in family, sends precheck confirmed email' do
    token = create(:precheck_email_token)

    assert_equal token.family.reload.precheck_status, 'pending_approval'
    assert_no_difference('PrecheckEmailToken.count') do
      assert_emails 1 do
        post :create, token: token.token
      end
    end
    assert_equal token.family.reload.precheck_status, 'approved'

    assigns(:family)
    last_email = ActionMailer::Base.deliveries.last
    assert_equal "MyConfName - Precheck Completed", last_email.subject
  end
end
