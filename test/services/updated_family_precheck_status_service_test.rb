require 'test_helper'

class UpdatedFamilyPrecheckStatusServiceTest < ServiceTestCase
  setup do
    @family = create :family, precheck_status: :pending_approval
    @attendee_one = create :attendee, family: @family, conference_status: Attendee::CONFERENCE_STATUSES.first
    @attendee_two = create :attendee, family: @family, conference_status: Attendee::CONFERENCE_STATUSES.first
  end

  def service
    UpdatedFamilyPrecheckStatusService.new family: @family
  end

  test 'changing to approved checks-in the attendees' do
    refute_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_one.reload.conference_status
    refute_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_two.reload.conference_status
    @family.update!(precheck_status: :approved)
    service.call
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_one.reload.conference_status
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_two.reload.conference_status
  end

  test 'changing to changes_requested does not affect attendees' do
    assert_no_difference -> { @attendee_one.reload.updated_at } do
      assert_no_difference -> { @attendee_two.reload.updated_at } do
        @family.update!(precheck_status: :changes_requested)
        service.call
      end
    end
  end
end
