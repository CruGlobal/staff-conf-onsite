class PrecheckMailer < ApplicationMailer
  def precheck_completed(family)
    email = family.attendees.pluck(:email).select(&:present?).compact
    mail(to: email, subject: "#{UserVariable[:conference_id]} - Precheck Completed")
  end

  def confirm_charges(family)
    @family = family
    @token = find_token(family)
    @finances = FamilyFinances::Report.call(family: family)
    @policy = Pundit.policy(User.find_by(role: 'finance'), family)
    to_email = family.attendees.pluck(:email).select(&:present?).compact
    mail(to: to_email, subject: "#{UserVariable[:conference_id]} - Precheck Confirmation Email")
  end

  def changes_requested(family, message)
    @family = family
    @message = message
    email = UserVariable[:support_email]
    mail(to: email, subject: "#{UserVariable[:conference_id]} - Precheck Modification Request")
  end

  private

  def find_token(family)
    family.precheck_email_token || family.create_precheck_email_token!
  end
end
