require 'test_helper'

class PrecheckMailerTest < MailTestCase

  setup do
    create(:user_variable, short_name: :CONFID, value_type: 'string', value: 'MyConfName')
    create(:user_variable, short_name: :CONFEMAIL, value_type: 'string', value: 'my_conf_email@example.org')
    create(:user_variable, short_name: :SUPPORTEMAIL, value_type: 'string', value: 'support@example.org')
    @family = build(:family)
  end

  test '#precheck_completed' do
    email = PrecheckMailer.precheck_completed(@family).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['my_conf_email@example.org'], email.from
    assert_equal ['josh.starcher@cru.org'], email.to
    assert_equal 'MyConfName - Precheck Completed', email.subject
  end

  test '#changes_requested' do
    email = PrecheckMailer.changes_requested(@family, "my name was mispelled").deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['my_conf_email@example.org'], email.from
    assert_equal ['support@example.org'], email.to
    assert_equal 'MyConfName - Precheck Modification Request', email.subject
    assert_match "<p>my name was mispelled</p>", email.body.to_s
  end

  test '#confirm_charges creates a auth token for the family' do
    @family.save
    assert_difference('PrecheckEmailToken.count', +1) do
      email = PrecheckMailer.confirm_charges(@family).deliver_now

      assert_not ActionMailer::Base.deliveries.empty?
  
      assert_equal ['my_conf_email@example.org'], email.from
      assert_equal ['josh.starcher@cru.org'], email.to
      assert_equal 'MyConfName - Precheck Confirmation Email', email.subject
    end
  end

  test '#confirm_charges with an existing token overwites it with a new one' do
    @family.save
    existing_token = create(:precheck_email_token, family: @family)

    assert_no_difference('PrecheckEmailToken.count') do
      email = PrecheckMailer.confirm_charges(@family).deliver_now

      assert_no_match existing_token.token, email.body.to_s
    end
  end
end
