require 'test_helper'

class Docusign::CreateEnvelopeFromTemplateTest < ServiceTestCase

  test 'with a valid payload returns a response with envelope id and status' do
    VCR.use_cassette('docusign/create_envelope_from_template_valid') do
      result = Docusign::CreateEnvelopeFromTemplate.new(valid_payload).call
      assert_equal 'sent', result['status']
      assert_equal 'ba1894c0-c7c0-42c2-84a5-8c22483b2034', result['envelopeId']
    end
  end

  test 'with an invalid payload raises and returns error message' do
    VCR.use_cassette('docusign/create_envelope_from_template_invalid') do
      exception = assert_raise(Docusign::CreateEnvelopeFromTemplate::DocusignError) { Docusign::CreateEnvelopeFromTemplate.new(invalid_payload).call }
      assert_equal("The request contained at least one invalid parameter. Invalid value specified for 'templateId'", exception.message )
    end
  end

  private

  def valid_payload
    {
      status: 'sent',
      email: {
        subject: 'Test Docusign Envelope',
        body: 'This is just a test'
      },
      template_id: '6dc20541-a4e1-4c25-9406-c1709a9c9527',
      signers: [
        {
          embedded: false,
          name: 'test_recipient',
          email: 'test_recipient@example.com',
          role_name: 'Signer',
        }
      ]
    }
  end

  def invalid_payload
    {
      status: 'sent',
      email: {
        subject: 'Test Docusign Envelope',
      },
      template_id: '12324324',
      signers: [
        {
          embedded: false,
          name: 'test_recipient',
          email: 'test_recipient@example.com',
        }
      ]
    }  
  end
end
