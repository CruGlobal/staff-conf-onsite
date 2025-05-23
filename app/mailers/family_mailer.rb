class FamilyMailer < ApplicationMailer
  helper(ApplicationHelper)
  helper(CostAdjustmentHelper)
  helper(PaymentHelper)

  def summary(family)
    @family = family
    @finances = FamilyFinances::Report.call(family: family)
    @policy = Pundit.policy(User.new(role: 'finance'), family)

    mail(to: to_family_attendees(family), subject: t('.subject', conference: UserVariable[:conference_id]))
  end

  def forms_approved(family, child)
    @family = family
    @child = child
    mail(to: to_family_attendees(family), subject: t('.subject', name: child.full_name_tag))
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
