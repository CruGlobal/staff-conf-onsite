# https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-emails

class MailInterceptor
  class << self
    def delivering_email(message)
      if intercept?
        message.to = interceptor_addresses
        message.cc = []
        message.bcc = []
      end

      message.bcc ||= []
      message.bcc << bcc_addresses

      return unless force_interception?

      message.to = interceptor_addresses
      message.cc = []
      message.bcc = bcc_addresses

      return if message.to.present?

      raise 'No interceptor email configured, please add one or more email addresses into the '\
            'mail_interceptor_email_addresses User Variable'
    end

    def force_interception?
      !Rails.env.production? && !Rails.env.test?
    end

    def intercept?
      interceptor_addresses.present?
    end

    def interceptor_addresses
      UserVariable[:mail_interceptor_email_addresses]
    rescue ArgumentError
      []
    end

    def bcc_addresses
      UserVariable[:mail_bcc_email_addresses]
    rescue ArgumentError
      []
    end
  end
end

ActionMailer::Base.register_interceptor(MailInterceptor)
