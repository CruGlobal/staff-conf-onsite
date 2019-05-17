require 'test_helper'

require_relative '../../../../db/user_variables'

class Precheck::RejectionController::CreateTest < IntegrationTest
  before do
    SeedUserVariables.new.call

    @eligible_family = create(:family)
    @eligible_family.create_precheck_email_token!
    create(:attendee, family: @eligible_family, arrived_at: 1.week.from_now, conference_status: Attendee::CONFERENCE_STATUSES.first)
    @eligible_family.housing_preference.update!(housing_type: :self_provided)
    create(:chargeable_staff_number, family: @eligible_family)
  end

  test '#create' do
    enable_javascript!

    visit precheck_status_path(token: @eligible_family.precheck_email_token.token)
    click_link 'No, I need to request changes...'
    fill_in 'message', with: 'Testing message.'
    click_button 'Submit Request'
    page.driver.browser.switch_to.alert.accept
    wait_for_ajax!

    assert_text 'Request received'
    assert @eligible_family.reload.changes_requested?
  end
end
