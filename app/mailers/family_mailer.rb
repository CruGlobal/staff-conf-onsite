class FamilyMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  add_template_helper(CostAdjustmentHelper)
  add_template_helper(PaymentHelper)

  def summary(family)
    @family = family
    @finances = FamilyFinances::Report.call(family: family)
    # Send email with the rights of a finance user
    finance_user = User.find_by(role: 'finance')
    @policy = Pundit.policy(finance_user, family)

    if Rails.env.production?
      emails = family.attendees.pluck(:email).select(&:present?).compact
    else
      emails = 'josh.starcher@cru.org'
    end
    mail(to: emails, subject: 'Cru17 Financial Summary')
  end
end
