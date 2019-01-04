class Childcare::VoidDocusignEnvelope < ApplicationService
  VoidEnvelopeError = Class.new(StandardError)

  attr_reader :envelope

  def initialize(envelope)
    @envelope = envelope
  end

  def call
    raise VoidEnvelopeError, 'Envelope is not voidable.' unless envelope.voidable?

    result = Docusign::VoidEnvelope.new(envelope.envelope_id).call
    envelope.update(status: 'voided') if result
  end
end
