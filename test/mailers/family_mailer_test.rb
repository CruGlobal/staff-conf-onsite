require 'test_helper'

require_relative '../../db/user_variables'

class FamilyMailerTest < ActionMailer::TestCase
  setup do
    SeedUserVariables.new.call
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).update!(value: [])
    @family = create(:family_with_members)
  end

  test '#summary' do
    email = FamilyMailer.summary(@family).deliver_now
    assert_not ActionMailer::Base.deliveries.empty?

    assert_equal ['no-reply@cru.org'], email.from
    assert_equal @family.attendees.map(&:email).sort, email.to.sort
    assert_equal 'Cru17 Financial Summary', email.subject
    assert_match 'Remaining Balance Due', email.body.to_s
  end
end
