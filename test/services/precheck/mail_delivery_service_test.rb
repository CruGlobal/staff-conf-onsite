require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::MailDeliveryServiceTest < ServiceTestCase
  setup do
    Sidekiq::Testing.inline!
    SeedUserVariables.new.call
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).update!(value: [])

    @eligible_family = create :family, precheck_status: :pending_approval
    @attendee = create :attendee, family: @eligible_family, arrived_at: 8.days.from_now, conference_status: Attendee::CONFERENCE_STATUSES.first
    create :child, family: @eligible_family, forms_approved: true, forms_approved_by: 'Tester',
                   grade_level: 'age1', childcare_weeks: [Childcare::CHILDCARE_WEEKS.first]
    create :chargeable_staff_number, family: @eligible_family
    @eligible_family.housing_preference.update! housing_type: :dormitory, confirmed_at: 1.day.ago
  end

  def service
    Precheck::MailDeliveryService.new(family: @eligible_family)
  end

  test '#deliver_pending_approval_mail delivers confirm_charges mail' do
    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      service.deliver_pending_approval_mail
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [@attendee.email], email.to
    assert_equal 'Cru17 - PreCheck Eligible', email.subject
    assert_match 'Review Registration', email.body.to_s
  end

  test '#deliver_pending_approval_mail delivers report_issues mail' do
    @eligible_family.children.first.update!(forms_approved: false, forms_approved_by: nil)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      service.deliver_pending_approval_mail
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [@attendee.email], email.to
    assert_equal 'Cru17 - Unconfirmed PreCheck Details', email.subject
    assert_match 'incomplete Cru19 Kids forms', email.body.to_s
  end

  test '#deliver_pending_approval_mail does not deliver if status is not pending_approval' do
    @eligible_family.update!(precheck_status: :changes_requested)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      service.deliver_pending_approval_mail
    end
  end

  test '#deliver_pending_approval_mail does not deliver if it is too late' do
    @attendee.update!(arrived_at: Time.zone.now)
    @eligible_family.reload

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      service.deliver_pending_approval_mail
    end
  end

  test '#deliver_pending_approval_mail does not deliver if attendee already checked in' do
    @attendee.check_in!
    @eligible_family.reload

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      service.deliver_pending_approval_mail
    end
  end

  test '#deliver_changes_requested_mail delivers changes_requested mail' do
    @eligible_family.update!(precheck_status: :changes_requested)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      service.deliver_changes_requested_mail('Hello World')
    end

    email = ActionMailer::Base.deliveries.last
    assert_equal ['no-reply@cru.org'], email.from
    assert_equal ['help@cru.org'], email.to
    assert_equal "Cru17 PreCheck Changes Requested for Family #{@eligible_family.to_s}", email.subject
    assert_match 'The following family has used the PreCheck form to request changes to their registration', email.body.to_s
    assert_match 'Hello World', email.body.to_s
  end

  test '#deliver_changes_requested_mail delivers even if the family is still in pending_approval' do
    @eligible_family.update!(precheck_status: :pending_approval)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      service.deliver_changes_requested_mail('Hello World')
    end
  end

  test '#deliver_changes_requested_mail does not deliver if it is too late' do
    @attendee.update!(arrived_at: Time.zone.now)
    @eligible_family.reload

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      service.deliver_changes_requested_mail('Hello World')
    end
  end

  test '#deliver_changes_requested_mail does not deliver if attendee already checked in' do
    @attendee.check_in!
    @eligible_family.reload

    assert_difference -> { ActionMailer::Base.deliveries.size }, 0 do
      service.deliver_changes_requested_mail('Hello World')
    end
  end
end
