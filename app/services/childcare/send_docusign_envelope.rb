class Childcare::SendDocusignEnvelope < ApplicationService
  SendEnvelopeError = Class.new(StandardError)

  # TODO: Update constants with real values.
  CHILDCARE_TEMPLATE_ID  = '1234-ABCD-abcd-1234'.freeze
  DOCUSIGN_EMAIL_SUBJECT = 'Testing docusign status'.freeze
  DOCUSIGN_EMAIL_BODY    = 'Envelope body content here'.freeze
  SIGNER_ROLE            = 'Parent'.freeze

  attr_reader :child, :recipient
  
  def initialize(child)
    @recipient = child.family.primary_person
    @child = child
  end

  def call
    raise SendEnvelopeError, 'Valid envelope already exists for child' if valid_envelope_exists?
    
    payload = build_payload(recipient.full_name, recipient.email, child)
    result = Docusign::CreateEnvelopeFromTemplate.new(payload).call

    if result && result['envelopeId']
      child.childcare_envelopes.create(envelope_id: result['envelopeId'], status: result['status'], recipient: recipient)
    end
  end

  private

  def valid_envelope_exists?
    child.completed_envelope? || child.pending_envelope?
  end

  def build_payload(recipient_name, recipient_email, child)
    {
      status: 'sent',
      email: build_docusign_email_block,
      template_id: CHILDCARE_TEMPLATE_ID,
      signers: [
        {
          embedded: false,
          name: recipient_name,
          email: recipient_email,
          role_name: SIGNER_ROLE,
          text_tabs: build_text_tabs(child)
        }
      ]
    }
  end

  def build_docusign_email_block
    {
      subject: DOCUSIGN_EMAIL_SUBJECT,
      body: DOCUSIGN_EMAIL_BODY
    }
  end

  # TODO: Fill with real labels and values.
  # Create a list of child or childform attributes that need to be passed to document
  # Check that column name is same as template name, otherwise match
  # For each attribute, create { label: attr_name, value: attr_value }
  def build_text_tabs(child)
    [
      {
        label: 'Alergies',
        value: 'Peanut Butter'
      },
      {
        label: 'Favourite Game',
        value: 'Tag'
      }
    ]
  end
end
