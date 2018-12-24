require 'test_helper'

class Childcare::SendDocusignEnvelopeTest < ServiceTestCase
  
  def setup
    VCR.turn_on!
    @family = create :family
    @attendee = create :attendee, family: @family, first_name: 'Test', last_name: 'Recipient', email: 'test@example.com'
    @child = create :child, family: @family
    @family.primary_person = @attendee
    @family.save
  end

  def teardown
    VCR.turn_off!
  end

  test 'valid payload' do
    VCR.use_cassette('docusign/childcare_send_valid_payload') do
      before = ChildcareEnvelope.count
      assert Childcare::SendDocusignEnvelope.call(@child)
      assert_equal(before + 1, ChildcareEnvelope.count)
    end
  end

  test 'if child already has an envelope marked as completed' do
    @completed = create :childcare_envelope, child: @child, recipient: @attendee, status: 'completed'

    VCR.use_cassette('docusign/childcare_send_valid_payload') do
      before = ChildcareEnvelope.count
      exception = assert_raise(Childcare::SendDocusignEnvelope::SendEnvelopeError) { Childcare::SendDocusignEnvelope.call(@child) }
      assert_equal('Valid envelope already exists for child', exception.message )
      assert_equal(before, ChildcareEnvelope.count)
    end
  end

  test 'with invalid template' do
    VCR.use_cassette('docusign/childcare_send_invalid_template') do
      before = ChildcareEnvelope.count
      exception = assert_raise(Docusign::CreateEnvelopeFromTemplate::DocusignError) { Childcare::SendDocusignEnvelope.call(@child) }
      assert_equal('Invalid template ID.', exception.message )
      assert_equal(before, ChildcareEnvelope.count)
    end
  end
end
