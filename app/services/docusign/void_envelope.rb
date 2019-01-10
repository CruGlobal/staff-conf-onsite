class Docusign::VoidEnvelope < ApplicationService
  DocusignError = Class.new(StandardError)

  DEFAULT_VOID_REASON = 'Envelope voided via admin page'.freeze

  attr_reader :envelope_id, :reason, :response

  def initialize(envelope_id, reason = DEFAULT_VOID_REASON)
    @envelope_id = envelope_id
    @reason = reason
  end

  def call
    client = DocusignRest::Client.new
    @response = client.void_envelope(envelope_id: envelope_id, voided_reason: reason)
    raise_docusign_error if unexpected_response?
    true
  end

  private

  def unexpected_response?
    !response.is_a?(Net::HTTPSuccess)
  end

  def raise_docusign_error
    response_body = JSON.parse(response.body)
    raise DocusignError, response_body['message']
  end
end
