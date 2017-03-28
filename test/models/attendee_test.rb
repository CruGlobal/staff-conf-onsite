require 'test_helper'

class AttendeeTest < ModelTestCase
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

  test 'must have family' do
    @attendee = build :attendee, family_id: nil
    refute @attendee.valid?, 'attendee should be invalid with nil family_id'
  end

  test 'must have a seminary' do
    refute @attendee.update(seminary_id: nil)
    assert @attendee.errors[:seminary_id].present?
  end

  test 'last_name should default to family name' do
    @family = create :family, last_name: 'FooBar'
    @attendee = create :attendee, family_id: @family.id, last_name: nil

    assert_equal 'FooBar', @attendee.last_name
  end

  test 'family name should not override explicit last_name' do
    @family = create :family, last_name: 'FooBar'
    @attendee = create :attendee, family_id: @family.id, last_name: 'OtherName'

    assert_equal 'OtherName', @attendee.last_name
  end
end
