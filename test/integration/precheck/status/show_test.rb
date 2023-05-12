require 'test_helper'

require_relative '../../../../db/user_variables'

class Precheck::StatusController::ShowTest < IntegrationTest
  setup do
    Sidekiq::Testing.inline!
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
    assert_text "Hello!"
    assert_text 'If your personal information and conference cost breakdown are correct'
    assert_text 'Remaining Balance Due $0'
  end

  test '#show as not eligible family' do
    visit precheck_status_path(token: @not_eligible_family.precheck_email_token.token)
    assert_text 'We are missing some conference details that will keep you from receiving PreCheck'
  end

  test '#show as not eligible family submits message' do
    visit precheck_status_path(token: @not_eligible_family.precheck_email_token.token)

    within('form') do
      fill_in 'message', with: 'Testing message.'
      assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
        click_button 'Submit'
      end
    end

    assert_text 'Thank you for contacting us'
  end

  test '#show as eligible family pending approval' do
    @eligible_family.update!(precheck_status: :pending_approval)
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text 'click “Yes, I accept my choices and charges”'
  end

  test '#show as previously eligible family now has changes requested' do
    @eligible_family.update!(precheck_status: :changes_requested)
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text 'your registration is undergoing review by our team'
  end

  test '#show as precheck approved' do
    @eligible_family.update!(precheck_status: :approved)
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text 'Congratulations! Your PreCheck has been completed - you have now received PreCheck.'
  end

  test '#show as checked in on site' do
    @eligible_family.update!(precheck_status: :pending_approval)
    @eligible_family.check_in!
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    assert_text 'Welcome to Cru22'
    refute_text 'received Cru22 PreCheck'
  end

  test '#show too late for precheck' do
    travel_to 5.days.from_now.end_of_day do
      visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
      assert_text 'If your personal information and conference cost breakdown are correct'
    end

    travel_to 7.days.from_now.beginning_of_day do
      visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
      assert_text 'We are sorry. PreCheck has closed and Team22 is working hard to prepare for your arrival.'
    end
  end
end
