require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::RejectionControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  stub_user_variable conference_id: 'MyConfName',
                     support_email: 'support@example.org',
                     conference_logo_url: 'https://www.logo.com',
                     mail_interceptor_email_addresses: []

  setup do
    Sidekiq::Testing.inline!
  end

  test '#create with an invalid auth token get error page' do
    post :create, params: { token: "sdfsdf" }
    assert_response :success
    assert_template :error
  end

  test '#create with a valid token sends change request email' do
    family = create(:family)

    assert_equal family.reload.precheck_status, 'pending_approval'
    assert_no_difference('PrecheckEmailToken.count') do
      assert_emails 1 do
        post :create, params: { token: family.precheck_email_token.token, message: "My name is misspelled" }
      end
    end
    assert_equal family.reload.precheck_status, 'changes_requested'

    last_email = ActionMailer::Base.deliveries.last
    assert_equal "MyConfName PreCheck Changes Requested for Family #{family}", last_email.subject
    assert_equal [UserVariable[:support_email]], last_email.to
  end

  test '#create when already in changes_requested state sends another change request email' do
    family = create(:family)
    family.update!(precheck_status: :changes_requested)

    assert_equal family.reload.precheck_status, 'changes_requested'
    assert_emails 1 do
      post :create, params: { token: family.precheck_email_token.token, message: "My name is misspelled" }
    end
    assert_equal family.reload.precheck_status, 'changes_requested'

    last_email = ActionMailer::Base.deliveries.last
    assert_equal "MyConfName PreCheck Changes Requested for Family #{family}", last_email.subject
    assert_equal [UserVariable[:support_email]], last_email.to
  end

  test '#create when already checked in' do
    family = create(:family)
    attendee = create(:attendee, family: family)
    attendee.check_in!

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      post :create, params: { token: family.precheck_email_token.token, message: "My name is misspelled" }
    end
    assert_redirected_to precheck_status_path
  end

  test '#create when already approved' do
    family = create(:family)
    attendee = create(:attendee, family: family)
    family.update!(precheck_status: :approved)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      post :create, params: { token: family.precheck_email_token.token, message: "My name is misspelled" }
    end
    assert_equal attendee.family.reload.precheck_status, 'approved'
    assert_redirected_to precheck_status_path
  end

  test '#create when precheck is too late' do
    family = create(:family)
    attendee = create(:attendee, family: family)
    Precheck::EligibilityService.stubs(:new).returns(stub("too_late_or_checked_in?": true))

    assert_equal attendee.family.precheck_status, 'pending_approval'

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      post :create, params: { token: family.precheck_email_token.token }
    end
    assert_equal attendee.family.reload.precheck_status, 'pending_approval'
    assert_redirected_to precheck_status_path
  end
end
