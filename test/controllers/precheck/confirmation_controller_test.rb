require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::ConfirmationControllerTest < ControllerTestCase
  include ActionMailer::TestHelper

  setup do
    Sidekiq::Testing.inline!
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
    Precheck::EligibilityService.stubs(:new).returns(stub(call: true, "too_late_or_checked_in?": false))

    assert_equal token.family.reload.precheck_status, 'pending_approval'
    assert_no_difference('PrecheckEmailToken.count') do
      assert_emails 1 do
        post :create, token: token.token
      end
    end
    assert_equal token.family.reload.precheck_status, 'approved'

    last_email = ActionMailer::Base.deliveries.last
    assert_equal 'Cru22 PreCheck Summary', last_email.subject
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

  test '#create when precheck eligibility expired' do
    token = create(:precheck_email_token)
    staff_number = create(:chargeable_staff_number)
    housing = create(:housing_preference, housing_type: 'self_provided')
    token.family.update(chargeable_staff_number: staff_number, housing_preference: housing)
    @attendee = create(:attendee, family: token.family, conference_status: 'Registered', arrived_at: 7.days.from_now)

    assert_equal @attendee.family.precheck_status, 'pending_approval'
    assert Precheck::EligibilityService.new(family: @attendee.family).call

    @attendee.update!(arrived_at: DateTime.current)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      post :create, token: token.token
    end
    assert_equal @attendee.family.reload.precheck_status, 'pending_approval'
    assert_redirected_to precheck_status_path
  end

  test '#create when precheck eligibility is false' do
    token = create(:precheck_email_token)
    @attendee = create(:attendee, family: token.family)
    assert_equal @attendee.family.precheck_status, 'pending_approval'

    Precheck::EligibilityService.stubs(:new).returns(stub(call: false))

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      post :create, token: token.token
    end
    assert_equal @attendee.family.reload.precheck_status, 'pending_approval'
    assert_redirected_to precheck_status_path
  end
end
