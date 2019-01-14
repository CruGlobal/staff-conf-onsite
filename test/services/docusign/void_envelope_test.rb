require 'test_helper'

class Docusign::VoidEnvelopeTest < ServiceTestCase
  setup do
    @envelope_id = 'e0a9e52d-dcfc-4983-9e50-a9ad644f2864'
  end

  test 'with a voidable envelope' do
    VCR.use_cassette('docusign/void_envelope') do
      assert Docusign::VoidEnvelope.new(@envelope_id).call
    end
  end

  test 'with an envelope aready voided' do
    VCR.use_cassette('docusign/void_envelope_already_voided') do
      exception = assert_raise(Docusign::VoidEnvelope::DocusignError) { Docusign::VoidEnvelope.new(@envelope_id).call }
      assert_equal("Only envelopes in the 'Sent' or 'Delivered' states may be voided.", exception.message )
    end
  end

  test 'with an invalid envelope_id raises and returns error message' do
    VCR.use_cassette('docusign/void_envelope_with_invalid_data') do
      exception = assert_raise(Docusign::VoidEnvelope::DocusignError) { Docusign::VoidEnvelope.new('123-abc').call }
      assert_equal("The request contained at least one invalid parameter. Invalid value specified for envelopeId.", exception.message )
    end
  end
end
