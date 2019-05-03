require 'test_helper'

class Childcare::SendDocusignEnvelopeTest < ServiceTestCase
  
  setup do
    @family = create :family
    @attendee = create :attendee, family: @family, first_name: 'Test', last_name: 'Recipient', email: 'test@example.com'
    @child = create :child, family: @family
    @family.primary_person = @attendee
    @family.save
  end
  
  stub_user_variable child_age_cutoff: 6.months.from_now.to_date

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

  test '#determine_docusign_template for a child on childcare grade and no misc health issues checked' do
    @child.grade_level = 'grade5'
    ChildcareMedicalHistory.new(child: @child, health_misc: ['None of the above'])
    docusign_envelope = Childcare::SendDocusignEnvelope.new(@child)

    stub_envelope_const('CARECAMP_TEMPLATE', 'template_key_stub') do
      assert_equal 'template_key_stub', docusign_envelope.send(:determine_docusign_template)
    end
  end

  test '#determine_docusign_template for a child on childcare grade and a misc health issue checked' do
    @child.grade_level = 'grade5'
    ChildcareMedicalHistory.new(child: @child, health_misc: ['Disability'])
    docusign_envelope = Childcare::SendDocusignEnvelope.new(@child)

    stub_envelope_const('CARECAMP_VIP_TEMPLATE', 'template_key_stub') do
      assert_equal 'template_key_stub', docusign_envelope.send(:determine_docusign_template)
    end
  end

  test '#determine_docusign_template for a child on senior grade and only no misc health issues checked on health misc' do
    @child.grade_level = 'grade6'
    CruStudentMedicalHistory.new(child: @child, cs_health_misc: ['None of the above'])
    docusign_envelope = Childcare::SendDocusignEnvelope.new(@child)

    stub_envelope_const('CRUSTU_TEMPLATE', 'template_key_stub') do
      assert_equal 'template_key_stub', docusign_envelope.send(:determine_docusign_template)
    end
  end

  test '#determine_docusign_template for a child on senior grade and a misc health issue checked' do
    @child.grade_level = 'grade6'
    CruStudentMedicalHistory.new(child: @child, cs_health_misc: ['Developmental delay', 'Sensory issues'])
    docusign_envelope = Childcare::SendDocusignEnvelope.new(@child)

    stub_envelope_const('CRUSTU_VIP_TEMPLATE', 'template_key_stub') do
      assert_equal 'template_key_stub', docusign_envelope.send(:determine_docusign_template)
    end
  end

  test '#determine_docusign_template when no answer for misc health issue, defaults to VIP template' do
    @child.grade_level = 'grade2'
    ChildcareMedicalHistory.new(child: @child, health_misc: nil)
    docusign_envelope = Childcare::SendDocusignEnvelope.new(@child)

    stub_envelope_const('CARECAMP_VIP_TEMPLATE', 'template_key_stub') do
      assert_equal 'template_key_stub', docusign_envelope.send(:determine_docusign_template)
    end
  end

  def stub_envelope_const(const, value)
    old = Childcare::SendDocusignEnvelope.const_get(const)
    Childcare::SendDocusignEnvelope.send(:remove_const, const)
    Childcare::SendDocusignEnvelope.const_set(const, value)
    yield
  ensure
    Childcare::SendDocusignEnvelope.send(:remove_const, const)
    Childcare::SendDocusignEnvelope.const_set(const, old)
  end
end
