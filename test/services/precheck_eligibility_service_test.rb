require 'test_helper'

require_relative '../../db/user_variables'

class PrecheckEligibilityServiceTest < ServiceTestCase
  setup do
    SeedUserVariables.new.call

    @eligible_family = create :family, precheck_status: :pending_approval

    create :attendee, family: @eligible_family, arrived_at: 8.days.from_now
    create :attendee, family: @eligible_family, arrived_at: 7.days.from_now

    create :child, family: @eligible_family, forms_approved: true, forms_approved_by: 'Tester',
                   grade_level: 'age1', childcare_weeks: [Childcare::CHILDCARE_WEEKS.first]
    create :child, family: @eligible_family, forms_approved: true, forms_approved_by: 'Tester',
                   grade_level: 'age4', childcare_weeks: [Childcare::CHILDCARE_WEEKS.second]

    create :chargeable_staff_number, family: @eligible_family

    @eligible_family.housing_preference.update! housing_type: :dormitory, confirmed_at: 1.day.ago
  end

  def service
    PrecheckEligibilityService.new family: @eligible_family
  end

  test 'initialize' do
    assert_kind_of PrecheckEligibilityService, service
    assert_equal @eligible_family, service.family
  end

  test 'eligible family' do
    assert_equal true, service.call
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

  test 'not eligible if 2 days before earliest attendee arrival' do
    travel_to 6.days.from_now do
      assert_equal false, service.call
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

  test '#reportable_errors is empty when family is eligible' do
    assert_equal [], service.reportable_errors
  end

  test '#reportable_errors reports error when no chargeable_staff_number and balance above 0' do
    FamilyFinances::Report.stubs(:call).returns(stub(remaining_balance: 1))
    @eligible_family.chargeable_staff_number.destroy!
    @eligible_family.reload
    assert_equal [:no_chargeable_staff_number_and_finance_balance_not_zero], service.reportable_errors
  end

  test '#reportable_errors reports error when child forms not approved' do
    @eligible_family.children.last.update! forms_approved: false, forms_approved_by: nil
    assert_equal [:children_forms_not_approved], service.reportable_errors
  end
end
