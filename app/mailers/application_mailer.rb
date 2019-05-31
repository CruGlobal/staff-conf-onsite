class ApplicationMailer < ActionMailer::Base
  default from: %("Cru" <no-reply@cru.org>)

  layout 'mailer'

  private

  def to_family_attendees(family)
    family.attendees.map do |attendee|
      to_email_with_name(attendee.email, attendee.full_name(skip_middle: true))
    end.select(&:present?)
  end

  def to_email_with_name(email, name)
    return if email.blank?

    name.delete!('"')
    return email if name.blank?

    %("#{name}" <#{email}>)
  end
end
