class UpdatedFamilyPrecheckStatusService < ApplicationService
  attr_accessor :family, :message

  def call
    return if family.previous_changes[:precheck_status].blank? && message.blank?

    send(family.precheck_status)
  end

  private

  def pending_approval
    PrecheckMailer.confirm_charges(family).deliver_now
  end

  def changes_requested
    PrecheckMailer.changes_requested(family, message).deliver_now
  end

  def approved
    family.check_in!
  end
end
