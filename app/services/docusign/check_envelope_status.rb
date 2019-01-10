class Docusign::CheckEnvelopeStatus < ApplicationService
  attr_reader :envelope_id

  def initialize(envelope_id)
    @envelope_id = envelope_id
  end

  def call
    client = DocusignRest::Client.new
    response = client.get_envelope_status(envelope_id: envelope_id)
    response['status']
  end
end
