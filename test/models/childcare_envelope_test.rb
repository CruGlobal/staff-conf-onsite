require 'test_helper'

class ChildcareEnvelopeTest < ModelTestCase

  def setup
    @attendee = build :attendee, family_id: 1
    @child = build :child, family_id: 1
    @subject = ChildcareEnvelope.new(envelope_id: "1234", status: "sent", recipient: @attendee, child: @child)
  end

  test 'valid childcare envelope' do
    assert @subject.valid?
  end

  test 'invalid without a docusign envelope id' do
    @subject.envelope_id = nil

    refute @subject.valid?
    assert_not_nil @subject.errors[:envelope_id], "can't be blank"
  end

  test 'invalid without a status' do
    @subject.status = nil

    refute @subject.valid?
    assert_not_nil @subject.errors[:status], "can't be blank"
  end

  test 'invalid if recipient and child do not belong to the same family' do
    @child.family_id = 2

    refute @subject.valid?
    assert_not_nil @subject.errors[:child], 'is not part of the recipients family'
  end

  test '#normalize_status' do
    @subject.status = " DELIVERED  "
    @subject.valid?
    
    assert_equal 'delivered', @subject.status
  end
end
