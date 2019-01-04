require 'test_helper'

class Childcare::VoidDocusignEnvelopeTest < ServiceTestCase

  test 'with a voidable envelope' do
    @envelope = build :childcare_envelope, :sent, envelope_id: '87840103-e43d-4817-be24-20b733552604'

    VCR.use_cassette('docusign/childcare_void_envelope') do
      Childcare::VoidDocusignEnvelope.new(@envelope).call
      assert_equal('voided', @envelope.status)
    end
  end

  test 'with an envelope already completed or void' do
    @envelope = build :childcare_envelope, :completed

    exception = assert_raise(Childcare::VoidDocusignEnvelope::VoidEnvelopeError) { Childcare::VoidDocusignEnvelope.new(@envelope).call }
    assert_equal("Envelope is not voidable.", exception.message )
  end

  test 'with an envelope already completed or voided on docusigns web interface' do
    @envelope = build :childcare_envelope, :sent, envelope_id: '87840103-e43d-4817-be24-20b733552604'

    VCR.use_cassette('docusign/childcare_void_envelope_when_already_voided') do
      exception = assert_raise(Docusign::VoidEnvelope::DocusignError) { Childcare::VoidDocusignEnvelope.new(@envelope).call }
      assert_equal("Only envelopes in the 'Sent' or 'Delivered' states may be voided.", exception.message )
      assert_equal('sent', @envelope.status)
    end
  end
end
