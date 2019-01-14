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

  def confirm_charges(family)
    @token = create_or_refresh_token(family)
    email = if Rails.env.production?
              family.attendees.pluck(:email).select(&:present?).compact
            else
              DEFAULT_EMAIL
            end
    mail(to: email, subject: 'Cru19 Precheck Confirmation Email')
  end

  def changes_requested(family, message)
    @family = family
    @message = message
    mail(to: DEFAULT_CHANGES_REQUEST_EMAIL, subject: "Cru19 Precheck Modification Request")
  end

  private

  def create_or_refresh_token(family)
    if family.precheck_email_token.present?
      family.precheck_email_token.delete
    end
    family.create_precheck_email_token
  end
end
