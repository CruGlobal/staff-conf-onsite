class PrecheckMailer < ApplicationMailer
  DEFAULT_EMAIL = 'josh.starcher@cru.org'.freeze

  def precheck_completed(family)
    email = if Rails.env.production?
              family.attendees.pluck(:email).select(&:present?).compact
            else
              DEFAULT_EMAIL
            end
    mail(to: email, subject: 'Cru19 - Precheck Completed')
  end
end
