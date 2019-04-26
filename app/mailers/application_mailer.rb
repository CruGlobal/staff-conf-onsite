class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@cru.org'

  layout 'mailer'
end
