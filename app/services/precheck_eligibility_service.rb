class PrecheckEligibilityService < ApplicationService
  attr_accessor :family

  def call
    within_time_window? &&
      children_forms_approved? &&
      housing_preference_confirmed? &&
      (chargeable_staff_number? || finance_balance_is_zero?)
  end

  def reportable_errors
    errors = []
    if !chargeable_staff_number? && !finance_balance_is_zero?
      errors << :no_chargeable_staff_number_and_finance_balance_not_zero
    end
    errors << :children_forms_not_approved unless children_forms_approved?
    errors
  end

  private

  def_delegator :family, :attendees
  def_delegator :family, :children
  def_delegator :family, :chargeable_staff_number?
  def_delegator :family, :housing_preference

  def within_time_window?
    return false if earliest_attendee_arrival_date.blank?

    earliest_precheck_date = earliest_attendee_arrival_date - 10.days
    latest_precheck_date   = earliest_attendee_arrival_date - 2.days

    (earliest_precheck_date..latest_precheck_date).cover? Time.zone.now
  end

  def earliest_attendee_arrival_date
    attendees.collect(&:arrived_at).compact.min
  end

  def children_forms_approved?
    children_requiring_forms_approval.all?(&:forms_approved?)
  end

  def children_requiring_forms_approval
    children.select { |child| child.childcare_weeks.present? }
  end

  def housing_preference_confirmed?
    return false if housing_preference.blank?

    return true if housing_preference.self_provided?

    housing_preference.confirmed_at.present?
  end

  def finance_balance_is_zero?
    finance_report.remaining_balance.zero?
  end

  def finance_report
    @finance_report ||= FamilyFinances::Report.call(family: family)
  end
end
