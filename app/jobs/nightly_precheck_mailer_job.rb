class NightlyPrecheckMailerJob < ApplicationJob
  queue_as :default

  def perform
    families_scope.find_each do |family|
      if precheck_eligible?(family)
        PrecheckMailer.confirm_charges(family).deliver_later
      elsif reportable_errors?(family)
        PrecheckMailer.report_issues(family).deliver_later
      end
    end
  end

  private

  def families_scope
    Family.includes(
      :chargeable_staff_number, :housing_preference, :payments, children: [:stays], attendees: [:stays]
    ).precheck_pending_approval
  end

  def eligibility_service(family)
    PrecheckEligibilityService.new(family: family)
  end

  def precheck_eligible?(family)
    eligibility_service(family).call
  end

  def reportable_errors?(family)
    eligibility_service(family).reportable_errors.present?
  end
end
