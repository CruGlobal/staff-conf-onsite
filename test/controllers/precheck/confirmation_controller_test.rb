require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::ConfirmationControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  setup do
    SeedUserVariables.new.call
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).update!(value: [])
  end

  test '#create with an invalid auth token get error page' do
    post :create, token: "sdfsdf"
    assert_response :success
    assert_template :error
  end

  test '#create with a valid token checks in family, sends precheck confirmed email' do
    token = create(:precheck_email_token)
    create(:attendee, family: token.family)

    assert_equal token.family.reload.precheck_status, 'pending_approval'
    assert_no_difference('PrecheckEmailToken.count') do
      assert_emails 1 do
        post :create, token: token.token
      end
    end
    assert_equal token.family.reload.precheck_status, 'approved'

    last_email = ActionMailer::Base.deliveries.last
    assert_equal 'Cru17 Financial Summary', last_email.subject
    assert_equal [token.family.attendees.first.email], last_email.to
  end

  test '#create when already approved does not resend email' do
    token = create(:precheck_email_token)
    create(:attendee, family: token.family)
    token.family.update!(precheck_status: :approved)

    assert_equal token.family.reload.precheck_status, 'approved'
    assert_no_difference('PrecheckEmailToken.count') do
      assert_emails 0 do
        post :create, token: token.token
      end
    end
    assert_equal token.family.reload.precheck_status, 'approved'
  end
end
