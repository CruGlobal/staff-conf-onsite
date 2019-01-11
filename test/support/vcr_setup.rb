VCR.configure do |c|
  c.cassette_library_dir = "test/vcr_cassettes"
  c.hook_into :webmock
  c.filter_sensitive_data("<DOCUSIGN_USER_NAME>") { ENV['DOCUSIGN_USER_NAME'] }
  c.filter_sensitive_data("<DOCUSIGN_PASSWORD>") { ENV['DOCUSIGN_PASSWORD'] }
  c.filter_sensitive_data("<DOCUSIGN_INTEGRATOR_KEY>") { ENV['DOCUSIGN_INTEGRATOR_KEY'] }
  c.filter_sensitive_data("<DOCUSIGN_ACCOUNT_ID>") { ENV['DOCUSIGN_ACCOUNT_ID'] }
end
