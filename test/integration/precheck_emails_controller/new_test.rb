require 'test_helper'

class PrecheckEmailsController::NewTest < IntegrationTest
  before do
    @family = create(:family)
    @token = @family.create_precheck_email_token!
  end

  stub_user_variable conference_logo_url: 'logo.png'

  test '#new invalid token' do
    visit precheck_email_path(auth_token: 'invalid-token')
    assert_text 'There was an error with your request'
  end

  test '#new' do
    visit precheck_email_path(auth_token: @token.token)
    assert_text "Hello #{@family.last_name} family!"
  end

  test '#new as family pending approval' do
    @family.update!(precheck_status: :pending_approval)
    visit precheck_email_path(auth_token: @token.token)
    assert_text 'please click below to confirm your precheck'
  end

  test '#new as family with changes requested' do
    @family.update!(precheck_status: :changes_requested)
    visit precheck_email_path(auth_token: @token.token)
    assert_text 'your registration is undergoing review by our support team'
  end
end
