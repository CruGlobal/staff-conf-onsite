# Determines whether a family is eligible to confirm (approve) their precheck or not.
# The requirements correspond closely to a flow chart diagram that was prepared by Cru:
# https://basecamp.com/2160769/projects/12693955/uploads/45614292?enlarge=372609602#attachment_372609602
module Precheck
  class EligibilityService < ApplicationService
    PRE_ACTION_REQUIREMENTS = %i[
      not_checked_in_already?
      not_changes_requested_status?
      not_too_late?
      not_too_early?
      housing_preference_confirmed?
    ].freeze

    ACTIONABLE_REQUIREMENTS = %i[
      chargeable_staff_number_or_zero_balance?
      children_forms_approved?
    ].freeze

    REQUIREMENTS = PRE_ACTION_REQUIREMENTS + ACTIONABLE_REQUIREMENTS

    attr_accessor :family

    def call
      all_requirements_met?
    end

    def errors
      REQUIREMENTS.reject do |requirement|
        send(requirement)
      end
    end

    def actionable_errors
      return [] unless pre_action_requirements_met?

      ACTIONABLE_REQUIREMENTS.reject do |requirement|
        send(requirement)
      end
    end

    def too_late_or_checked_in?
      too_late? || checked_in_already?
    end

    def too_late?
      return unless last_precheck_time

      !not_too_late?
    end

    def children_without_approved_forms
      children_requiring_forms_approval.reject(&:forms_approved?)
    end

    private

    def_delegator :family, :approved?
    def_delegator :family, :changes_requested?
    def_delegator :family, :pending_approval?

    def_delegator :family, :attendees
    def_delegator :family, :children
    def_delegator :family, :housing_preference

    def_delegator :family, :chargeable_staff_number?

    def all_requirements_met?
      pre_action_requirements_met? &&
        actionable_requirements_met?
    end

    def pre_action_requirements_met?
      PRE_ACTION_REQUIREMENTS.all? do |requirement|
        send(requirement)
      end
    end

    def actionable_requirements_met?
      ACTIONABLE_REQUIREMENTS.all? do |requirement|
        send(requirement)
      end
    end

    def not_checked_in_already?
      !approved? && !family.checked_in?
    end

    def checked_in_already?
      !not_checked_in_already?
    end

    def not_changes_requested_status?
      !changes_requested?
    end

    def not_too_late?
      return unless last_precheck_time

      Time.zone.now < last_precheck_time
    end

    def not_too_early?
      return unless earliest_precheck_time

      Time.zone.now > earliest_precheck_time
    end

    def earliest_precheck_time
      return unless earliest_attendee_arrival_date

      (earliest_attendee_arrival_date - 18.days).beginning_of_day
    end

    def last_precheck_time
      return unless earliest_attendee_arrival_date

      (earliest_attendee_arrival_date - 1.day).beginning_of_day + 8.hours
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

    def chargeable_staff_number_or_zero_balance?
      chargeable_staff_number? || finance_balance_is_zero?
    end

    def finance_balance_is_zero?
      finance_report.remaining_balance.zero?
    end

    def finance_report
      @finance_report ||= FamilyFinances::Report.call(family: family)
    end
  end
end
