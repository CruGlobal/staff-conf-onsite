require 'test_helper'

require_relative '../../../../db/user_variables'

class Precheck::ConfirmationController::CreateTest < IntegrationTest
  before do
    SeedUserVariables.new.call

    @eligible_family = create(:family)
    @eligible_family.create_precheck_email_token!
    create(:attendee, family: @eligible_family, arrived_at: 1.week.from_now, conference_status: Attendee::CONFERENCE_STATUSES.first)
    @eligible_family.housing_preference.update!(housing_type: :self_provided)
    create(:chargeable_staff_number, family: @eligible_family)
  end

  test '#create' do
    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    click_button 'Yes, I accept my choices and charges'
    select 'Airbnb or VRBO', :from => 'hotel'
    click_button 'Submit'
    
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax!
    
    assert_text 'Congratulations! You have received PreCheck'
    assert @eligible_family.reload.approved?
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @eligible_family.attendees.first.conference_status

  end
end
