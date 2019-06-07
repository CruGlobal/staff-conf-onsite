require 'test_helper'

require_relative '../../../db/user_variables'

class Precheck::EligibilityServiceTest < ServiceTestCase
  setup do
    SeedUserVariables.new.call

    @eligible_family = create :family, precheck_status: :pending_approval

    create :attendee, family: @eligible_family, arrived_at: 8.days.from_now, conference_status: Attendee::CONFERENCE_STATUSES.first
    create :attendee, family: @eligible_family, arrived_at: 7.days.from_now, conference_status: Attendee::CONFERENCE_STATUSES.first

    create :child, family: @eligible_family, forms_approved: true, forms_approved_by: 'Tester',
                   grade_level: 'age1', childcare_weeks: [Childcare::CHILDCARE_WEEKS.first]
    create :child, family: @eligible_family, forms_approved: true, forms_approved_by: 'Tester',
                   grade_level: 'age4', childcare_weeks: [Childcare::CHILDCARE_WEEKS.second]

    create :chargeable_staff_number, family: @eligible_family

    @eligible_family.housing_preference.update! housing_type: :dormitory, confirmed_at: 1.day.ago
  end

  def service
    Precheck::EligibilityService.new family: @eligible_family
  end

  def family_with_actionable_errors
    @eligible_family.children.last.update! forms_approved: false, forms_approved_by: nil
    assert_equal [:children_forms_approved?], service.actionable_errors
    @eligible_family
  end

  test 'initialize' do
    assert_kind_of Precheck::EligibilityService, service
    assert_equal @eligible_family, service.family
  end

  test 'eligible family' do
    assert_equal true, service.call
  end

  test 'not eligible if an attendee is already checked in' do
    @eligible_family.attendees.first.update!(conference_status: Attendee::CONFERENCE_STATUS_CHECKED_IN)
    assert_equal false, service.call
  end

  test 'not eligible if family has accepted precheck' do
    @eligible_family.update!(precheck_status: :approved)
    assert_equal false, service.call
  end

  test 'not eligible if family has requested changes' do
    @eligible_family.update!(precheck_status: :changes_requested)
    assert_equal false, service.call
  end

  test 'not eligible if attendees do not have an arrival date' do
    @eligible_family.attendees.each { |attendee| attendee.update!(arrived_at: nil) }
    assert_equal false, service.call
  end

  test 'not eligible if more than 10 days before earliest attendee arrival' do
    travel_to 5.days.ago do
      assert_equal false, service.call
    end
  end

  test 'not eligible if more than 8am the previous day before earliest attendee arrival' do
    travel_to 6.days.from_now.beginning_of_day + 8.hours do
      assert_equal false, service.call
    end

    travel_to 6.days.from_now.beginning_of_day + 7.hours do
      assert_equal true, service.call
    end
  end

  test 'not eligible if children are not approved' do
    @eligible_family.children.last.update! forms_approved: false, forms_approved_by: nil
    assert_equal false, service.call
  end

  test 'eligible if children do not have childcare_weeks while forms are not approved' do
    @eligible_family.children.last.update! forms_approved: false, forms_approved_by: nil, childcare_weeks: []
    assert_equal true, service.call
  end

  test 'not eligible if no chargeable_staff_number and balance is above zero' do
    FamilyFinances::Report.stubs(:call).returns(stub(remaining_balance: 1))
    @eligible_family.chargeable_staff_number.destroy!
    @eligible_family.reload
    assert_equal false, service.call
  end

  test 'eligible if no chargeable_staff_number and balance is zero' do
    FamilyFinances::Report.stubs(:call).returns(stub(remaining_balance: 0))
    @eligible_family.chargeable_staff_number.destroy!
    @eligible_family.reload
    assert_equal true, service.call
  end

  test 'eligible if chargeable_staff_number and balance is above zero' do
    FamilyFinances::Report.stubs(:call).returns(stub(remaining_balance: 1))
    assert_equal true, service.call
  end

  test 'not eligible if no housing_preference' do
    @eligible_family.housing_preference.destroy!
    @eligible_family.reload
    assert_equal false, service.call
  end

  test 'not eligible if dormitory housing_preference not confirmed' do
    @eligible_family.housing_preference.update! housing_type: :dormitory, confirmed_at: nil
    @eligible_family.reload
    assert_equal false, service.call
  end

  test 'not eligible if apartment housing_preference not confirmed' do
    @eligible_family.housing_preference.update! housing_type: :apartment, confirmed_at: nil
    @eligible_family.reload
    assert_equal false, service.call
  end

  test 'eligible if self_provided housing_preference not confirmed' do
    @eligible_family.housing_preference.update! housing_type: :self_provided, confirmed_at: nil
    @eligible_family.reload
    assert_equal true, service.call
  end

  test '#errors is empty when family is eligible' do
    assert_equal [], service.errors
  end

  test '#errors present when family is checked in' do
    @eligible_family.check_in!
    assert_equal [:not_checked_in_already?], service.errors
  end

  test '#errors present when family is changes requested' do
    @eligible_family.update!(precheck_status: :changes_requested)
    assert_equal [:not_changes_requested_status?], service.errors
  end

  test '#errors present when outside arrival window' do
    travel_to 1.month.from_now do
      assert_equal [:not_too_late?], service.errors
    end
  end

  test '#errors present when housing_preference not confirmed' do
    @eligible_family.housing_preference.update!(confirmed_at: nil)
    assert_equal [:housing_preference_confirmed?], service.errors
  end

  test '#actionable_errors is empty when family is eligible' do
    assert_equal [], service.actionable_errors
  end

  test '#actionable_errors is empty if attendees do not have an arrival date' do
    family_with_actionable_errors.attendees.each { |attendee| attendee.update!(arrived_at: nil) }
    assert_equal [], service.actionable_errors
  end

  test '#actionable_errors is empty if more than 10 days before earliest attendee arrival' do
    family_with_actionable_errors
    travel_to 5.days.ago do
      assert_equal [], service.actionable_errors
    end
  end

  test '#actionable_errors is empty if 2 days before earliest attendee arrival' do
    family_with_actionable_errors
    travel_to 6.days.from_now do
      assert_equal [], service.actionable_errors
    end
  end

  test '#actionable_errors is always empty if family is precheck approved' do
    family_with_actionable_errors.update!(precheck_status: :approved)
    assert_equal [], service.actionable_errors
  end

  test '#actionable_errors can be present if family is precheck pending' do
    family_with_actionable_errors.update!(precheck_status: :pending_approval)
    assert_equal true, service.actionable_errors.present?
  end

  test '#actionable_errors is always empty if family is precheck changes_requested' do
    family_with_actionable_errors.update!(precheck_status: :changes_requested)
    assert_equal [], service.actionable_errors
  end

  test '#actionable_errors is always empty if any attendee is checked in' do
    family_with_actionable_errors.update!(precheck_status: :pending_approval)
    @eligible_family.attendees.first.update!(conference_status: Attendee::CONFERENCE_STATUS_CHECKED_IN)
    assert_equal [], service.actionable_errors
  end

  test '#actionable_errors reports error when no chargeable_staff_number and balance above 0' do
    FamilyFinances::Report.stubs(:call).returns(stub(remaining_balance: 1))
    @eligible_family.chargeable_staff_number.destroy!
    @eligible_family.reload
    assert_equal [:chargeable_staff_number_or_zero_balance?], service.actionable_errors
  end

  test '#actionable_errors reports error when child forms not approved' do
    @eligible_family.children.last.update! forms_approved: false, forms_approved_by: nil
    assert_equal [:children_forms_approved?], service.actionable_errors
  end

  test '#too_late? is false' do
    travel_to 5.days.ago { assert_equal false, service.too_late? }
    travel_to 4.days.from_now { assert_equal false, service.too_late? }
    travel_to 2.years.ago { assert_equal false, service.too_late? }
    assert_equal false, service.too_late?
  end

  test '#too_late? is true' do
    travel_to 5.days.from_now { assert_equal true, service.too_late? }
    travel_to 6.days.from_now { assert_equal true, service.too_late? }
    travel_to 2.years.from_now { assert_equal true, service.too_late? }
  end

  test '#too_late? is nil' do
    @eligible_family.attendees.update_all(arrived_at: nil)
    @eligible_family.reload
    assert_nil service.too_late?
  end

  test '#too_late_or_checked_in? is false' do
    travel_to 2.days.ago do
      @eligible_family.attendees.first.update!(conference_status: Attendee::CONFERENCE_STATUSES[1])
      assert_equal false, service.too_late_or_checked_in?
    end
  end

  test '#too_late_or_checked_in? is true' do
    travel_to 6.days.from_now do
      @eligible_family.attendees.first.update!(conference_status: Attendee::CONFERENCE_STATUSES[1])
      assert_equal true, service.too_late_or_checked_in?
    end

    travel_to 4.days.from_now do
      @eligible_family.attendees.first.update!(conference_status: Attendee::CONFERENCE_STATUS_CHECKED_IN)
      assert_equal true, service.too_late_or_checked_in?
    end

    travel_to 8.days.from_now do
      @eligible_family.attendees.first.update!(conference_status: Attendee::CONFERENCE_STATUS_CHECKED_IN)
      assert_equal true, service.too_late_or_checked_in?
    end

  end

  test '#children_without_approved_forms' do
    @eligible_family.children.last.update! forms_approved: false, forms_approved_by: nil
    assert_equal [@eligible_family.children.last], service.children_without_approved_forms
  end
end
