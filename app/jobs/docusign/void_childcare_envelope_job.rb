class Docusign::VoidChildcareEnvelopeJob < ApplicationJob
  queue_as :default

  # Stop from retrying if envelope is already voided, declined or completed
  rescue_from(Childcare::VoidDocusignEnvelope::VoidEnvelopeError) do |exception|
    Rollbar.error(exception)
    Rails.logger.error "[#{self.class.name}] Something went wrong with you job: #{exception}"
  end

  def perform(envelope)
    Childcare::VoidDocusignEnvelope.new(envelope).call
  end
end
