class FamilyMailer < ApplicationMailer
  def summary(family)
    @family = family
    @finances = FamilyFinances::Report.call(family: family)
    # Send email with the rights of a finance user
    finance_user = User.find_by(role: 'finance')
    @policy = Pundit.policy(finance_user, family)

    emails = family.attendees.pluck(:email)
    mail(to: 'josh.starcher@cru.org', subject: 'Cru17 Financial Summary')
  end
end
