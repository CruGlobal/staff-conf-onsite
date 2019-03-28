class PrecheckEligibilityService < ApplicationService
  attr_accessor :family

  def call
    pending_approval? &&
      within_time_window? &&
      children_approved? &&
      chargeable_staff_number? &&
      housing_preference_confirmed?
  end

  private

  def_delegator :family, :pending_approval?
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

  def children_approved?
    children.all?(&:medical_history_approval?)
  end

  def housing_preference_confirmed?
    return false if housing_preference.blank?

    return true if housing_preference.self_provided?

    housing_preference.confirmed_at.present?
  end
end
