class NightlyPrecheckMailerJob < ApplicationJob
  queue_as :default

  def perform
    families_scope.find_each do |family|
      next unless precheck_eligible? family

      PrecheckMailer.confirm_charges(family).deliver_later
    end
  end

  private

  def families_scope
    Family.includes(:attendees, :chargeable_staff_number, :children, :housing_preference).precheck_pending_approval
  end

  def precheck_eligible?(family)
    PrecheckEligibilityService.new(family).call
  end
end
