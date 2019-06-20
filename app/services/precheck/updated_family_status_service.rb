module Precheck
  class UpdatedFamilyStatusService < ApplicationService
    attr_accessor :family, :message

    def call
      return if family.previous_changes[:precheck_status].blank? && message.blank?

      send(family.precheck_status)
    end

    private

    def delivery_service
      Precheck::MailDeliveryService.new(family: family)
    end

    def pending_approval
      delivery_service.deliver_pending_approval_mail
    end

    def changes_requested
      delivery_service.deliver_changes_requested_mail(message)
    end

    def approved
      family.check_in!
    end
  end
end
