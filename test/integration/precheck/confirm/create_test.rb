require 'test_helper'

require_relative '../../../../db/user_variables'

class Precheck::StatusController::ShowTest < IntegrationTest
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
    click_button 'Confirm PreCheck'
    assert_text 'Your family have been successfully confirmed as prechecked'
    assert @eligible_family.reload.approved?
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @eligible_family.attendees.first.conference_status
  end
end
