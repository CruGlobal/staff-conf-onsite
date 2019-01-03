require 'test_helper'

class Childcare::SendDocusignEnvelopeTest < ServiceTestCase
  
  def setup
    VCR.configure do |c|
      c.filter_sensitive_data("<DOCUSIGN_USER_NAME>") { ENV['DOCUSIGN_USER_NAME'] }
      c.filter_sensitive_data("<DOCUSIGN_PASSWORD>") { ENV['DOCUSIGN_PASSWORD'] }
      c.filter_sensitive_data("<DOCUSIGN_INTEGRATOR_KEY>") { ENV['DOCUSIGN_INTEGRATOR_KEY'] }
      c.filter_sensitive_data("<DOCUSIGN_ACCOUNT_ID>") { ENV['DOCUSIGN_ACCOUNT_ID'] }
    end

    @family = create :family
    @attendee = create :attendee, family: @family, first_name: 'Test', last_name: 'Recipient', email: 'test@example.com'
    @child = create :child, family: @family
    @family.primary_person = @attendee
    @family.save
  end

  test 'valid payload' do
    VCR.use_cassette('docusign/childcare_send_valid_payload') do
      before = ChildcareEnvelope.count
      assert Childcare::SendDocusignEnvelope.call(@child)
      assert_equal(before + 1, ChildcareEnvelope.count)
    end
  end

  test 'if child already has an envelope marked as completed' do
    @completed = create :childcare_envelope, :completed, child: @child, recipient: @attendee

    VCR.use_cassette('docusign/childcare_send_valid_payload') do
      before = ChildcareEnvelope.count
      exception = assert_raise(Childcare::SendDocusignEnvelope::SendEnvelopeError) { Childcare::SendDocusignEnvelope.call(@child) }
      assert_equal('Valid envelope already exists for child', exception.message )
      assert_equal(before, ChildcareEnvelope.count)
    end
  end
end
