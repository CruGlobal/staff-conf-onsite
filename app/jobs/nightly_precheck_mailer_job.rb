class NightlyPrecheckMailerJob < ApplicationJob
  queue_as :default

  def perform
    families_scope.find_each do |family|
      Precheck::MailDeliveryService.new(family: family).deliver_pending_approval_mail
    end
  end

  private

  def families_scope
    Family.includes(
      :chargeable_staff_number, :housing_preference, :payments, children: [:stays], attendees: [:stays]
    ).precheck_pending_approval
  end
end
