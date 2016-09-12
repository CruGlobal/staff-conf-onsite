require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  setup do
    create_users
    @attendee = create :attendee
  end

  test 'permit create' do
    assert_permit @general_user, @attendee, :create
    assert_permit @finance_user, @attendee, :create
    assert_permit @admin_user, @attendee, :create
  end

  test 'permit read' do
    assert_permit @general_user, @attendee, :show
    assert_permit @finance_user, @attendee, :show
    assert_permit @admin_user, @attendee, :show
  end

  test 'permit update' do
    assert_permit @general_user, @attendee, :update
    assert_permit @finance_user, @attendee, :update
    assert_permit @admin_user, @attendee, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @attendee, :destroy
    assert_permit @finance_user, @attendee, :destroy
    assert_permit @admin_user, @attendee, :destroy
  end
end
