module Precheck
  class MailDeliveryService < ApplicationService
    attr_accessor :family

    def deliver_pending_approval_mail
      return unless family.pending_approval?
      return if too_late_or_checked_in?

      if precheck_eligible?
        PrecheckMailer.confirm_charges(family).deliver_later
      elsif actionable_errors?
        PrecheckMailer.report_issues(family).deliver_later
      end
    end

    def deliver_changes_requested_mail(message)
      return if too_late_or_checked_in?

      PrecheckMailer.changes_requested(family, message).deliver_later
    end

    private

    def eligibility_service
      EligibilityService.new(family: family)
    end

    def precheck_eligible?
      eligibility_service.call
    end

    def actionable_errors?
      eligibility_service.actionable_errors.present?
    end

    def too_late_or_checked_in?
      eligibility_service.too_late_or_checked_in?
    end
  end
end
