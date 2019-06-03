require 'test_helper'

class ApplicationMailerTest < MailTestCase
  setup do
    @family = create(:family)
    @attendee_one = create(:attendee, family: @family, first_name: 'Bob', middle_name: 'Middle', last_name: 'Tester', email: 'bob@test.com')
    @attendee_two = create(:attendee, family: @family, first_name: 'Granny', last_name: 'Tester', email: nil)
    @attendee_three = create(:attendee, family: @family, first_name: 'Sue', last_name: 'Tester', email: 'sue@test.com')
  end

  test 'default from is present' do
    assert true, ApplicationMailer.default[:from].present?
  end

  test 'to_family_attendees' do
    assert_equal [%("Bob Tester" <bob@test.com>), %("Sue Tester" <sue@test.com>)].sort, ApplicationMailer.send(:new).send(:to_family_attendees, @family).sort
  end
end
