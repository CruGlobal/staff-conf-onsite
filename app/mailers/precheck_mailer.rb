class PrecheckMailer < ApplicationMailer
  def precheck_completed(family)
    email = family.attendees.pluck(:email).select(&:present?).compact
    mail(to: email, subject: "#{UserVariable[:conference_id]} - Precheck Completed")
  end

  def confirm_charges(family, finance_user)
    @token = create_or_refresh_token(family)
    @family = family
    @finances = FamilyFinances::Report.call(family: family)
    @from_email = true
    finance_user = User.find_by(role: 'finance') if finance_user.blank?
    @policy = Pundit.policy(finance_user, family)
    email = family.attendees.pluck(:email).select(&:present?).compact
    mail(to: email, subject: "#{UserVariable[:conference_id]} - Precheck Confirmation Email")
  end

  def changes_requested(family, message)
    @family = family
    @message = message
    email = UserVariable[:support_email]
    mail(to: email, subject: "#{UserVariable[:conference_id]} - Precheck Modification Request")
  end

  private

  def create_or_refresh_token(family)
    if family.precheck_email_token.present?
      family.precheck_email_token.delete
    end
    family.create_precheck_email_token
  end
end
