module Precheck
  class UpdatedFamilyStatusService < ApplicationService
    attr_accessor :family, :message

    def call
      return if family.previous_changes[:precheck_status].blank? && message.blank?

      send(family.precheck_status)
    end

    private

    def pending_approval
      PrecheckMailer.confirm_charges(family).deliver_now unless too_late_or_checked_in?
    end

    def changes_requested
      PrecheckMailer.changes_requested(family, message).deliver_now unless too_late_or_checked_in?
    end

    def approved
      family.check_in!
    end

    def too_late_or_checked_in?
      EligibilityService.new(family: @family).too_late_or_checked_in?
    end
  end
end
