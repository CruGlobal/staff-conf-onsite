class PrecheckEligibilityService < ApplicationService
  attr_accessor :family

  def call
    !checked_in_already? &&
      !changes_requested? &&
      within_time_window? &&
      housing_preference_confirmed? &&
      children_forms_approved? &&
      finances_okay?
  end

  def actionable_errors
    errors = []

    return errors if checked_in_already? ||
                     changes_requested? ||
                     !within_time_window? ||
                     !housing_preference_confirmed?

    errors << :no_chargeable_staff_number_and_finance_balance_not_zero unless finances_okay?
    errors << :children_forms_not_approved unless children_forms_approved?
    errors
  end

  private

  def_delegator :family, :changes_requested?
  def_delegator :family, :pending_approval?
  def_delegator :family, :approved?
  def_delegator :family, :attendees
  def_delegator :family, :children
  def_delegator :family, :chargeable_staff_number?
  def_delegator :family, :housing_preference

  def checked_in_already?
    approved? || attendees.any?(&:checked_in?)
  end

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

  def finances_okay?
    chargeable_staff_number? || finance_balance_is_zero?
  end

  def finance_balance_is_zero?
    finance_report.remaining_balance.zero?
  end

  def finance_report
    @finance_report ||= FamilyFinances::Report.call(family: family)
  end
end
