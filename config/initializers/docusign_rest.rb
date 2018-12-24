require 'docusign_rest'

DocusignRest.configure do |config|
  if Rails.env.test?
    config.username       = 'docusign_test@example.com'
    config.password       = '1234abcd'
    config.integrator_key = 'aabbccdd'
    config.account_id     = '123456'
    config.endpoint       = 'https://demo.docusign.net/restapi'
  else
    config.username       = ENV['DOCUSIGN_USER_NAME']
    config.password       = ENV['DOCUSIGN_PASSWORD']
    config.integrator_key = ENV['DOCUSIGN_INTEGRATOR_KEY']
    config.account_id     = ENV['DOCUSIGN_ACCOUNT_ID']
    config.endpoint       = ENV['DOCUSIGN_ENDPOINT'] || 'https://demo.docusign.net/restapi'
  end
end
