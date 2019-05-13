class UpdatedFamilyPrecheckStatusService < ApplicationService
  attr_accessor :family

  def call
    return unless family.previous_changes[:precheck_status]

    approved if family.approved?
  end

  private

  def approved
    Attendee.transaction do
      family.attendees.each(&:check_in!)
    end
  end
end
