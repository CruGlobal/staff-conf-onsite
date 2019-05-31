class PrecheckMailer < ApplicationMailer
  add_template_helper(PrecheckHelper)

  def confirm_charges(family)
    @family = family
    @token = find_token(family)
    @finances = FamilyFinances::Report.call(family: family)
    @policy = Pundit.policy(User.new(role: 'finance'), family)

    mail(to: to_family_attendees(family), subject: t('.subject', conference: UserVariable[:conference_id]))
  end

  def changes_requested(family, message)
    @family = family
    @message = message

    mail(to: UserVariable[:support_email], subject: t('.subject', conference: UserVariable[:conference_id], family: @family.to_s))
  end

  def report_issues(family)
    @family = family
    @token = find_token(family)

    mail(to: to_family_attendees(family), subject: t('.subject', conference: UserVariable[:conference_id]))
  end

  private

  def find_token(family)
    family.precheck_email_token || family.create_precheck_email_token!
  end
end
