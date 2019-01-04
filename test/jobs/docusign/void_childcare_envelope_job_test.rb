require 'test_helper'

class Docusign::VoidChildcareEnvelopeJobTest < JobTestCase

  def setup
    super
    @envelope = create(:childcare_envelope, :sent)
  end

  test 'it updates the envelope status to voided' do
    mock = mock(call: true)
    Docusign::VoidEnvelope.stubs(:new).returns(mock)

    Docusign::VoidChildcareEnvelopeJob.perform_now(@envelope)
    assert 'voided', @envelope.status
  end

  test 'when the envelope is already voided or completed it cleanly finishes the job' do
    @envelope.stubs(:voidable?).returns(false)

    assert_nothing_raised { Docusign::VoidChildcareEnvelopeJob.perform_now(@envelope) }
  end
end
