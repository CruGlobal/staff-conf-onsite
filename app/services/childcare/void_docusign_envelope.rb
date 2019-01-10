class Childcare::VoidDocusignEnvelope < ApplicationService
  VoidEnvelopeError = Class.new(StandardError)

  attr_reader :envelope

  def initialize(envelope)
    @envelope = envelope
  end

  def call
    raise VoidEnvelopeError, 'Envelope is not voidable.' unless envelope.voidable?

    begin
      result = Docusign::VoidEnvelope.new(envelope.envelope_id).call
      envelope.update(status: 'voided') if result
    rescue Docusign::VoidEnvelope::DocusignError => exception
      update_status_from_docusign if status_outdated?(exception)
      Rollbar.error(exception)
      Rails.logger.error "[#{self.class.name}] Something went wrong with you job: #{exception}"
    end
  end

  private

  def status_outdated?(exception)
    exception.message == "Only envelopes in the 'Sent' or 'Delivered' states may be voided."
  end

  # Update local envelope status if status is out of sync between app and docusign
  # because a change is done directly on the docusign page.
  def update_status_from_docusign
    current_status = Docusign::CheckEnvelopeStatus.new(envelope.envelope_id).call
    envelope.update(status: current_status) if current_status
  end
end
