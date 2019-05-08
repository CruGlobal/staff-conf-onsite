require 'test_helper'

require_relative '../../db/user_variables'

class PrecheckMailerTest < MailTestCase
  setup do
    SeedUserVariables.new.call
    @finance_user = create(:finance_user)
    @family = create(:family_with_members)
  end

  test '#precheck_completed' do
    email = PrecheckMailer.precheck_completed(@family).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@cru.org'], email.from
    assert_equal ['interceptor_one@example.com', 'interceptor_two@example.com'], email.to
    assert_equal 'Cru17 - Precheck Completed', email.subject
  end

  test '#changes_requested' do
    email = PrecheckMailer.changes_requested(@family, "my name was mispelled").deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@cru.org'], email.from
    assert_equal ['interceptor_one@example.com', 'interceptor_two@example.com'], email.to
    assert_equal 'Cru17 - Precheck Modification Request', email.subject
    assert_match "<p>my name was mispelled</p>", email.body.to_s
  end

  test '#confirm_charges creates a auth token for the family' do
    @family.save
    assert_difference('PrecheckEmailToken.count', +1) do
      email = PrecheckMailer.confirm_charges(@family, @finance_user).deliver_now

      assert_not ActionMailer::Base.deliveries.empty?

      assert_equal ['no-reply@cru.org'], email.from
      assert_equal ['interceptor_one@example.com', 'interceptor_two@example.com'], email.to
      assert_equal 'Cru17 - Precheck Confirmation Email', email.subject
    end
  end

  test '#confirm_charges with an existing token uses the existing token' do
    @family.save
    existing_token = create(:precheck_email_token, family: @family)

    assert_no_difference('PrecheckEmailToken.count') do
      email = PrecheckMailer.confirm_charges(@family, @finance_user).deliver_now

      assert_match existing_token.token, email.body.to_s
    end
  end
end
