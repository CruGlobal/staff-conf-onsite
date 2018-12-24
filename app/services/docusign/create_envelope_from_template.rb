class Docusign::CreateEnvelopeFromTemplate < ApplicationService
  DocusignError = Class.new(StandardError)
  
  attr_reader :payload

  def initialize(payload)
    @payload = payload
  end

  def call
    client = DocusignRest::Client.new
    result = client.create_envelope_from_template(payload)
    raise DocusignError, result['message'] if result['errorCode']

    result
  end
end
