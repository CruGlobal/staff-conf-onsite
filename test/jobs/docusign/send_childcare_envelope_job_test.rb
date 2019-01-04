require 'test_helper'

class Docusign::SendChildcareEnvelopeJobTest < JobTestCase

  def setup
    @attendee = build_stubbed(:attendee, last_name: 'Testerman')
    @child = build_stubbed(:child, family: @attendee.family)
    @attendee.family.primary_person = @attendee
  end

  test 'send childcare envelope job' do
    assert_enqueued_with(job: Docusign::SendChildcareEnvelopeJob) do
      @child.send_docusign_envelope
    end
  end

  test 'when a valid envelope already exists' do
    @child.stub :completed_envelope?, true do
      assert_nothing_raised { Docusign::SendChildcareEnvelopeJob.perform_now(@child) }
    end
  end
end
