class Docusign::SendChildcareEnvelopeJob < ApplicationJob
  queue_as :default

  # Stop from retrying if valid envelope already exists
  rescue_from(Childcare::SendDocusignEnvelope::SendEnvelopeError) do |exception|
    Rollbar.error(exception)
    Rails.logger.error "[#{self.class.name}] Something went wrong with your job: #{exception}"
  end

  # Stop from retrying if error on docusign configuration
  rescue_from(Docusign::CreateEnvelopeFromTemplate::DocusignError) do |exception|
    Rollbar.error(exception)
    Rails.logger.error "[#{self.class.name}] Something went wrong with your job: #{exception}"
  end

  def perform(child, note = nil, recipient = nil)
    Childcare::SendDocusignEnvelope.new(child, note, recipient: recipient).call
  end
end
