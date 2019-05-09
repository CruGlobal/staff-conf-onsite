require 'test_helper'

require_relative '../../../db/user_variables'

class PrecheckEmailsController::NewTest < IntegrationTest
  before do
    SeedUserVariables.new.call

    @not_eligible_family = create(:family)
    @not_eligible_family.create_precheck_email_token!

    @eligible_family = create(:family)
    @eligible_family.create_precheck_email_token!
    create(:attendee, family: @eligible_family, arrived_at: 1.week.from_now)
    @eligible_family.housing_preference.update!(housing_type: :self_provided)
    create(:chargeable_staff_number, family: @eligible_family)
  end

  test '#new invalid token' do
    visit precheck_email_path(auth_token: 'invalid-token')
    assert_text 'There was an error with your request'
  end

  test '#new' do
    visit precheck_email_path(auth_token: @eligible_family.precheck_email_token.token)
    assert_text "Hello #{@eligible_family.last_name} family!"
  end

  test '#new as not eligible family' do
    visit precheck_email_path(auth_token: @not_eligible_family.precheck_email_token.token)
    assert_text 'You are not eligible for precheck'
  end

  test '#new as not eligible family submits message' do
    visit precheck_email_path(auth_token: @not_eligible_family.precheck_email_token.token)

    within('form') do
      fill_in 'message', with: 'Testing message.'
      assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
        click_button 'Submit'
      end
    end

    assert_text 'The conference team have been notified'
  end

  test '#new as eligible family pending approval' do
    @eligible_family.update!(precheck_status: :pending_approval)
    visit precheck_email_path(auth_token: @eligible_family.precheck_email_token.token)
    assert_text 'please click below to confirm your precheck'
  end

  test '#new as eligible family with changes requested' do
    @eligible_family.update!(precheck_status: :changes_requested)
    visit precheck_email_path(auth_token: @eligible_family.precheck_email_token.token)
    assert_text 'your registration is undergoing review by our support team'
  end
end
