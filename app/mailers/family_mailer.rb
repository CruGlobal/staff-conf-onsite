class FamilyMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)
  add_template_helper(CostAdjustmentHelper)
  add_template_helper(PaymentHelper)

  def summary(family)
    @family = family
    @finances = FamilyFinances::Report.call(family: family)
    @policy = Pundit.policy(User.new(role: 'finance'), family)

    mail(to: to_family_attendees(family), subject: t('.subject', conference: UserVariable[:conference_id]))
  end

  # def media_release(family)
  #   @family = family
  #
  #   emails = family.attendees.pluck(:email).select(&:present?).compact
  #
  #   mail(to: emails,
  #        from: 'cru17.mediaReleases@cru.org',
  #        subject: 'IMPORTANT: Please Read')
  # end
end
