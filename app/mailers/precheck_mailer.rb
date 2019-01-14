class PrecheckMailer < ApplicationMailer
  DEFAULT_EMAIL = 'josh.starcher@cru.org'.freeze
  DEFAULT_CHANGES_REQUEST_EMAIL = 'josh.starcher@cru.org'.freeze

  def precheck_completed(family)
    email = if Rails.env.production?
              family.attendees.pluck(:email).select(&:present?).compact
            else
              DEFAULT_EMAIL
            end
    mail(to: email, subject: 'Cru19 - Precheck Completed')
  end

  def changes_requested(family, message)
    @family = family
    @message = message
    mail(to: DEFAULT_CHANGES_REQUEST_EMAIL, subject: "Cru19 Precheck Modification Request")
  end
end
