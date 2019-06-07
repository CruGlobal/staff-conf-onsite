require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::UpdatedFamilyStatusServiceTest < ServiceTestCase
  setup do
    SeedUserVariables.new.call
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).update!(value: [])

    @family = create :family, precheck_status: :pending_approval
    @attendee_one = create :attendee, family: @family, conference_status: Attendee::CONFERENCE_STATUSES.first
    @attendee_two = create :attendee, family: @family, conference_status: Attendee::CONFERENCE_STATUSES.first
  end

  test 'changing status from changes_requested to pending_approval does not affect attendee' do
    @family.update!(precheck_status: :changes_requested)
    @family.reload.update!(precheck_status: :pending_approval)

    assert_no_difference -> { @attendee_one.reload.updated_at } do
      assert_no_difference -> { @attendee_two.reload.updated_at } do
        Precheck::UpdatedFamilyStatusService.new(family: @family).call
      end
    end
  end

  test 'changing status from changes_requested to pending_approval sends mail' do
    @family.update!(precheck_status: :changes_requested)
    @family.reload.update!(precheck_status: :pending_approval)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      Precheck::UpdatedFamilyStatusService.new(family: @family).call
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [@attendee_one.email, @attendee_two.email], email.to
    assert_equal 'Cru17 - PreCheck Eligible', email.subject
    assert_match 'Review Registration', email.body.to_s
  end

  test 'changing status does not send email if too late' do
    @family.update!(precheck_status: :changes_requested)
    @family.reload.update!(precheck_status: :pending_approval)
    @attendee_one.update(arrived_at: Time.zone.now)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      Precheck::UpdatedFamilyStatusService.new(family: @family).call
    end
  end

  test 'changing status does not send email if attendee already checked in' do
    @family.update!(precheck_status: :pending_approval)
    @family.reload.update!(precheck_status: :changes_requested)
    @attendee_one.update(conference_status: Attendee::CONFERENCE_STATUS_CHECKED_IN)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      Precheck::UpdatedFamilyStatusService.new(family: @family).call
    end
  end

  test 'updating the family without changing the status does not send mail' do
    @family.update!(city: "Gotham", precheck_status: :pending_approval)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      Precheck::UpdatedFamilyStatusService.new(family: @family).call
    end
  end

  test 'changing to approved checks-in the attendees' do
    refute_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_one.reload.conference_status
    refute_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_two.reload.conference_status
    @family.update!(precheck_status: :approved)
    Precheck::UpdatedFamilyStatusService.new(family: @family).call
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_one.reload.conference_status
    assert_equal Attendee::CONFERENCE_STATUS_CHECKED_IN, @attendee_two.reload.conference_status
  end

  test 'changing to approved sends the family summary email' do
    @family.update!(precheck_status: :approved)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      Precheck::UpdatedFamilyStatusService.new(family: @family).call
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal @family.attendees.map(&:email).sort, email.to.sort
    assert_equal 'Cru17 Financial Summary', email.subject
    assert_match 'Congratulations! You have received <b>PreCheck</b>.', email.body.to_s
  end

  test 'changing to changes_requested does not affect attendees' do
    @family.update!(precheck_status: :changes_requested)

    assert_no_difference -> { @attendee_one.reload.updated_at } do
      assert_no_difference -> { @attendee_two.reload.updated_at } do
        Precheck::UpdatedFamilyStatusService.new(family: @family).call
      end
    end
  end

  test 'changing to changes_requested sends mail' do
    @family.update!(precheck_status: :changes_requested)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      Precheck::UpdatedFamilyStatusService.new(family: @family, message: 'Test 1 2 3').call
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
      Precheck::UpdatedFamilyStatusService.new(family: @family, message: 'Test 1 2 3').call
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [UserVariable[:support_email]], email.to
    assert_equal "Cru17 PreCheck Changes Requested for Family #{@family.to_s}", email.subject
    assert_match 'Test 1 2 3', email.body.to_s
  end
end
