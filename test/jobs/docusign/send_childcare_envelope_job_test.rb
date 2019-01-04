require 'test_helper'

class Docusign::SendChildcareEnvelopeJobTest < JobTestCase

  def setup
    super
    @attendee = build_stubbed(:attendee, last_name: 'Testerman')
    @child = build_stubbed(:child, family: @attendee.family)
    @attendee.family.primary_person = @attendee
  end

  test 'when a valid envelope already exists' do
    @child.stubs(:completed_envelope?).returns(true)
    assert_nothing_raised { Docusign::SendChildcareEnvelopeJob.perform_now(@child) }
  end
end
