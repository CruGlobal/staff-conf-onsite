require 'test_helper'

class FamilyTest < ModelTestCase
  setup do
    create_users
    @family = create :family
  end

  test 'permit create' do
    assert_accessible :create, @family, only: [:admin, :finance, :general]
  end

  test 'permit read' do
    assert_accessible :show, @family,
      only: [:admin, :finance, :general, :read_only]
  end

  test 'permit update' do
    assert_accessible :update, @family, only: [:admin, :finance, :general]
  end

  test 'permit destroy' do
    assert_accessible :destroy, @family, only: [:admin, :finance]
  end

  test '#chargeable_staff_number?' do
    @family.staff_number = '12345'
    chargeable = create :chargeable_staff_number, staff_number: '12345'

    assert @family.chargeable_staff_number?
  end

  test '#chargeable_staff_number? with no match' do
    @family.staff_number = '12345'
    ChargeableStaffNumber.where(staff_number: '12345').destroy_all

    refute @family.chargeable_staff_number?
  end

  test 'automatically update precheck_status_changed_at' do
    old_value = @family.precheck_status_changed_at
    @family.update!(precheck_status: Family.precheck_statuses.keys.second)
    refute_equal old_value, @family.precheck_status_changed_at
  end

  test 'scope precheck_pending_approval' do
    pending_family = create :family, precheck_status: :pending_approval
    create :family, precheck_status: :changes_requested
    create :family, precheck_status: :approved

    assert_equal [pending_family, @family].sort, Family.precheck_pending_approval.to_a.sort
  end

  test 'scope precheck_changes_requested' do
    create :family, precheck_status: :pending_approval
    changes_requested_family = create :family, precheck_status: :changes_requested
    create :family, precheck_status: :approved

    assert_equal [changes_requested_family], Family.precheck_changes_requested.to_a
  end

  test 'scope precheck_approved' do
    create :family, precheck_status: :pending_approval
    create :family, precheck_status: :changes_requested
    approved_family = create :family, precheck_status: :approved

    assert_equal [approved_family], Family.precheck_approved.to_a
  end

  test '#update_spouses updates two attendees' do
    attendee_one = create :attendee, family: @family
    assert_nil attendee_one.reload.spouse
    attendee_two = create :attendee, family: @family
    assert_equal attendee_one.reload.spouse, attendee_two
    assert_equal attendee_two.reload.spouse, attendee_one
  end

  test '#update_spouses sets spouse to nil if there are more than two attendees' do
    attendee_one = create :attendee, family: @family
    attendee_two = create :attendee, family: @family
    assert_equal attendee_one.reload.spouse, attendee_two
    attendee_three = create :attendee, family: @family
    assert_nil attendee_one.reload.spouse
    assert_nil attendee_two.reload.spouse
    assert_nil attendee_three.reload.spouse
  end

  test '#update_spouses sets spouse to nil if there are less than two attendees' do
    attendee_one = create :attendee, family: @family
    attendee_two = create :attendee, family: @family
    assert_equal attendee_one.reload.spouse, attendee_two
    attendee_two.destroy
    assert_nil attendee_one.reload.spouse
  end

  test '#update_spouses ignores children' do
    attendee_one = create :attendee, family: @family
    child_one = create :child, family: @family
    assert_nil attendee_one.reload.spouse
    attendee_two = create :attendee, family: @family
    assert_equal attendee_one.reload.spouse, attendee_two
    child_one.destroy
    assert_equal attendee_one.reload.spouse, attendee_two
  end

  test '#required_team_action ignores empty strings' do
    @family.required_team_action = ['', 'Housing']

    assert ['Housing'], @family.required_team_action
  end

  test '#required_team_action defaults to empty array when nil' do
    @family.required_team_action = nil

    assert [], @family.required_team_action
  end
end
