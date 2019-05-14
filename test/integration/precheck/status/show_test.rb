require 'test_helper'

require_relative '../../../../db/user_variables'

class Precheck::StatusController::ShowTest < IntegrationTest
  before do
    SeedUserVariables.new.call

    @not_eligible_family = create(:family)
    @not_eligible_family.create_precheck_email_token!

    @eligible_family = create(:family)
    @eligible_family.create_precheck_email_token!
    create(:attendee, family: @eligible_family, arrived_at: 1.week.from_now, conference_status: Attendee::CONFERENCE_STATUSES.first)
    @eligible_family.housing_preference.update!(housing_type: :self_provided)
    create(:chargeable_staff_number, family: @eligible_family)
  end

  test '#show invalid token' do
    visit precheck_status_path(token: 'invalid-token')
    assert_text 'There was an error with your request'
  end

  test '#show' do
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text "Hello #{@eligible_family.last_name} family!"
  end

  test '#show as not eligible family' do
    visit precheck_status_path(token: @not_eligible_family.precheck_email_token.token)
    assert_text 'You are not eligible for PreCheck'
  end

  test '#show as not eligible family submits message' do
    visit precheck_status_path(token: @not_eligible_family.precheck_email_token.token)

    within('form') do
      fill_in 'message', with: 'Testing message.'
      assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
        click_button 'Submit'
      end
    end

    assert_text 'The conference team has been notified'
  end

  test '#show as eligible family pending approval' do
    @eligible_family.update!(precheck_status: :pending_approval)
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text 'please click below to confirm your PreCheck'
  end

  test '#show as previously eligible family now has changes requested' do
    @eligible_family.update!(precheck_status: :changes_requested)
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text 'your registration is undergoing review by our team'
  end
end
