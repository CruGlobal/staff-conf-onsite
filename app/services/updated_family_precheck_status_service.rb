class UpdatedFamilyPrecheckStatusService < ApplicationService
  attr_accessor :family, :message

  def call
    return unless family.previous_changes[:precheck_status]

    send(family.precheck_status)
  end

  private

  def pending_approval; end

  def changes_requested
    PrecheckMailer.changes_requested(family, message).deliver_now
  end

  def approved
    family.check_in!
  end
end
