require 'test_helper'

require_relative '../../db/user_variables'

class UpdatedFamilyPrecheckStatusServiceTest < ServiceTestCase
  setup do
    SeedUserVariables.new.call
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).update!(value: [])

    @family = create :family, precheck_status: :pending_approval
    @attendee_one = create :attendee, family: @family, conference_status: Attendee::CONFERENCE_STATUSES.first
    @attendee_two = create :attendee, family: @family, conference_status: Attendee::CONFERENCE_STATUSES.first
  end

  test 'changing to pending_approval does nothing' do
    @family.update!(precheck_status: :changes_requested)
    @family.reload.update!(precheck_status: :pending_approval)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      assert_no_difference -> { @attendee_one.reload.updated_at } do
        assert_no_difference -> { @attendee_two.reload.updated_at } do
          UpdatedFamilyPrecheckStatusService.new(family: @family).call
        end
      end
    end
  end

  test 'changing to approved checks-in the attendees' do
    refute_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_one.reload.conference_status
    refute_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_two.reload.conference_status
    @family.update!(precheck_status: :approved)
    UpdatedFamilyPrecheckStatusService.new(family: @family).call
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_one.reload.conference_status
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_two.reload.conference_status
  end

  test 'changing to approved sends the family summary email' do
    @family.update!(precheck_status: :approved)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      UpdatedFamilyPrecheckStatusService.new(family: @family).call
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal @family.attendees.map(&:email).sort, email.to.sort
    assert_equal 'Cru17 Financial Summary', email.subject
    assert_match 'Congratulations! You and your family (if applicable) have received Cru17 PreCheck.', email.body.to_s
  end

  test 'changing to changes_requested does not affect attendees' do
    @family.update!(precheck_status: :changes_requested)

    assert_no_difference -> { @attendee_one.reload.updated_at } do
      assert_no_difference -> { @attendee_two.reload.updated_at } do
        UpdatedFamilyPrecheckStatusService.new(family: @family).call
      end
    end
  end

  test 'changing to changes_requested sends mail' do
    @family.update!(precheck_status: :changes_requested)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      UpdatedFamilyPrecheckStatusService.new(family: @family, message: 'Test 1 2 3').call
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [UserVariable[:support_email]], email.to
    assert_equal "Cru17 PreCheck Changes Requested for Family #{@family.to_s}", email.subject
    assert_match 'Test 1 2 3', email.body.to_s
  end

  test 'if a message is provided always send the email' do
    @family.update!(precheck_status: :changes_requested)
    @family.reload

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      UpdatedFamilyPrecheckStatusService.new(family: @family, message: 'Test 1 2 3').call
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [UserVariable[:support_email]], email.to
    assert_equal "Cru17 PreCheck Changes Requested for Family #{@family.to_s}", email.subject
    assert_match 'Test 1 2 3', email.body.to_s
  end
end
