require 'test_helper'

class ChildcareEnvelopeTest < ModelTestCase

  def setup
    super
    @attendee = build :attendee
    @child = build :child, family: @attendee.family
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

  test 'invalid with an unknown status' do
    @subject.status = 'preparing'

    refute @subject.valid?
    assert_not_nil @subject.errors[:status], 'is not included in the list'
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

  test '#voidable?' do
    assert @subject.voidable?

    @subject.status = 'completed'
    refute @subject.voidable?

    @subject.status = 'voided'
    refute @subject.voidable?
  end
end
