require 'webmock'

# Stub out HTTP requests to the remote CAS service, for testing / development.
# If an email address is provided in the request (the typical cas), we return
# that email address as the user's GUID.
class StubCas
  include WebMock::API

  DOMAIN_RE = /thekey\.me/

  def self.stub_requests
    new.call
  end

  def call
    WebMock.enable!

    stub_request(:get, DOMAIN_RE).to_return do |req|
      if (email = req.uri.query_values['email'])
        {status: 201, body: "{\"ssoGuid\": \"#{email}\"}"}
      else
        {status: 201, body: '{}'}
      end
    end
  end
end
