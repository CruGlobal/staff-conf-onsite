require 'test_helper'

class PrecheckEligibilityServiceTest < ServiceTestCase
  setup do
    @eligible_family = create :family, precheck_status: :pending_approval

    create :attendee, family: @eligible_family, arrived_at: 8.days.from_now
    create :attendee, family: @eligible_family, arrived_at: 7.days.from_now

    create :child, family: @eligible_family, medical_history_approval: true
    create :child, family: @eligible_family, medical_history_approval: true

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

  test 'not eligible if family precheck_status is approved' do
    @eligible_family.update! precheck_status: :approved
    assert_equal false, service.call
  end

  test 'not eligible if family precheck_status is changes_requested' do
    @eligible_family.update! precheck_status: :changes_requested
    assert_equal false, service.call
  end

  test 'not eligible if family precheck_status is nil' do
    @eligible_family.update! precheck_status: nil
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

  test 'not eligible if 2 days before earliest attendee arrival' do
    travel_to 6.days.from_now do
      assert_equal false, service.call
    end
  end

  test 'not eligible if children are not all approved' do
    @eligible_family.children.last.update! medical_history_approval: false
    assert_equal false, service.call
  end

  test 'not eligible if no chargeable_staff_number' do
    @eligible_family.chargeable_staff_number.destroy!
    @eligible_family.reload
    assert_equal false, service.call
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
end
