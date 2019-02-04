class ApplicationMailer < ActionMailer::Base
  default from: UserVariable[:CONFEMAIL]
  layout 'mailer'
end
