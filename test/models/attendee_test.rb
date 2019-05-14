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

  test 'default seminary should be IBS' do
    SeedSeminaries.new.call

    refute_nil Seminary.default
    assert_equal Attendee.new.seminary, Seminary.default
  end

  test 'automatically update conference_status_changed_at' do
    old_value = @attendee.conference_status_changed_at
    travel_to 1.minute.from_now do
      @attendee.update!(conference_status: 'some new value')
      refute_equal old_value, @attendee.conference_status_changed_at
    end
  end

  test '#main_ministry is the 1st child of the top level ministry' do
    @global_ministry   = build_stubbed :ministry
    @regional_ministry = build_stubbed :ministry, parent: @global_ministry
    @zone_ministry     = build_stubbed :ministry, parent: @regional_ministry
    @local_ministry    = build_stubbed :ministry, parent: @zone_ministry
    @attendee.ministry = @local_ministry

    assert_equal @regional_ministry, @attendee.main_ministry
  end

  test '#main_ministry when top level or no ancestors' do
    @global_ministry   = build_stubbed :ministry
    @attendee.ministry = @global_ministry

    assert_equal @global_ministry, @attendee.main_ministry
  end

  test '#main_ministry when attendee has no ministry defined' do
    @attendee.update(ministry: nil)

    assert_nil @attendee.main_ministry
  end

  test '#cohort is the 2nd child from the top level when attendees main ministry is campus ministry' do
    @global_ministry   = build_stubbed :ministry
    @regional_ministry = build_stubbed :ministry, parent: @global_ministry, code: "CM"
    @zone_ministry     = build_stubbed :ministry, parent: @regional_ministry
    @local_ministry    = build_stubbed :ministry, parent: @zone_ministry
    @attendee.ministry = @local_ministry

    assert_equal @zone_ministry, @attendee.cohort
  end

  test '#cohort when atendee main ministry is not campus ministry' do
    @global_ministry   = build_stubbed :ministry
    @regional_ministry = build_stubbed :ministry, parent: @global_ministry, code: "RANDOM"
    @zone_ministry     = build_stubbed :ministry, parent: @regional_ministry
    @local_ministry    = build_stubbed :ministry, parent: @zone_ministry
    @attendee.ministry = @local_ministry

    assert_nil @attendee.cohort
  end

  test '#cohort when attendee has no ministry defined' do
    @attendee.update(ministry: nil)

    assert_nil @attendee.cohort
  end
end
