class NightlyPrecheckMailerJob < ApplicationJob
  queue_as :default

  def perform
    Family.precheck_pending_approval.find_each do |family|
      next unless precheck_eligible?(family)

      PrecheckMailer.confirm_charges(family).deliver_later
    end
  end

  private

  def precheck_eligible?(family)
    PrecheckEligibilityService.new(family).eligible?
  end
end
