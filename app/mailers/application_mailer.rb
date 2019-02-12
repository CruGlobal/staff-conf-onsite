class ApplicationMailer < ActionMailer::Base
  begin
    default from: UserVariable[:conference_email]
  rescue ArgumentError
    default from: 'no-reply@cru.org'
  end

  layout 'mailer'
end
