class NightlyPrecheckMailerJob < ApplicationJob
  queue_as :default

  def perform
    families_scope.find_each do |family|
      deliver_pending_approval_mail(family)
    end
  end

  private

  def deliver_pending_approval_mail(family)
    return unless family.pending_approval?

    if precheck_eligible?(family)
      PrecheckMailer.confirm_charges(family).deliver_later
    elsif actionable_errors?(family)
      PrecheckMailer.report_issues(family).deliver_later
    end
  end

  def families_scope
    Family.includes(
      :chargeable_staff_number, :housing_preference, :payments, children: [:stays], attendees: [:stays]
    ).precheck_pending_approval
  end

  def eligibility_service(family)
    Precheck::EligibilityService.new(family: family)
  end

  def precheck_eligible?(family)
    eligibility_service(family).call
  end

  def actionable_errors?(family)
    eligibility_service(family).actionable_errors.present?
  end
end
