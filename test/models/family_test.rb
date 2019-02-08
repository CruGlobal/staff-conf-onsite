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
end
