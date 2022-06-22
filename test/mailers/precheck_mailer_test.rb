require 'test_helper'

require_relative '../../db/user_variables'

class PrecheckMailerTest < MailTestCase
  setup do
    SeedUserVariables.new.call
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).update!(value: [])
    @family = create(:family_with_members)
  end

  test '#changes_requested' do
    email = PrecheckMailer.changes_requested(@family, "my name was mispelled").deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@cru.org'], email.from
    assert_equal [UserVariable[:support_email]], email.to
    assert_equal "Cru22 PreCheck Changes Requested for Family #{@family.to_s}", email.subject
    assert_match 'my name was mispelled', email.body.to_s

    @family.attendees.each do |attendee|
      assert_match attendee.email, email.body.to_s
    end
  end

  test '#confirm_charges creates a auth token for the family' do
    @family.save
    assert_difference('PrecheckEmailToken.count', +1) do
      email = PrecheckMailer.confirm_charges(@family).deliver_now

      assert_not ActionMailer::Base.deliveries.empty?

      assert_equal ['no-reply@cru.org'], email.from
      assert_equal @family.attendees.map(&:email).sort, email.to.sort
      assert_equal 'Cru22 - PreCheck Eligible', email.subject
    end
  end

  test '#confirm_charges with an existing token uses the existing token' do
    @family.save
    existing_token = create(:precheck_email_token, family: @family)

    assert_no_difference('PrecheckEmailToken.count') do
      email = PrecheckMailer.confirm_charges(@family).deliver_now

      assert_match existing_token.token, email.body.to_s
    end
  end

  test '#report_issues' do
    Precheck::EligibilityService.stubs(:new).returns(stub(actionable_errors: [:children_forms_not_approved]))
    email = PrecheckMailer.report_issues(@family).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@cru.org'], email.from
    assert_equal @family.attendees.map(&:email).sort, email.to.sort
    assert_equal 'Cru22 - Unconfirmed PreCheck Details', email.subject
    assert_match 'children_forms_not_approved', email.body.to_s
    assert_match @family.precheck_email_token.token, email.body.to_s
  end
end
