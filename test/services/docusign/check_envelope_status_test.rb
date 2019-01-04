require 'test_helper'

class Docusign::CheckEnvelopeStatusTest < ServiceTestCase
  def setup
    super
    @envelope_id = 'd56a61b1-ac74-43ae-81f0-63e592890f93'
  end

  test 'with a valid envelope_id it gets back its status' do
    VCR.use_cassette('docusign/check_envelope_status_valid') do
      assert_equal 'voided', Docusign::CheckEnvelopeStatus.new(@envelope_id).call
    end
  end

  test 'with an invalid envelope id it returns nil' do
    VCR.use_cassette('docusign/check_envelope_status_invalid') do
      assert_nil Docusign::CheckEnvelopeStatus.new('aaabbbccc').call
    end   
  end
end
