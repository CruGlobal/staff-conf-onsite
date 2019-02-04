require 'test_helper'

class PrecheckEmailTokenTest < ModelTestCase
  setup do
    @family = build(:family)
  end

  test 'valid precheck email token requires a family' do
    @subject = PrecheckEmailToken.new(family: @family)
    assert @subject.valid?
  end

  test 'auto generates a token on initialization' do
    @subject = PrecheckEmailToken.new
    assert @subject.token
  end

  test 'is invalid without a family' do
    @subject = PrecheckEmailToken.new
    refute @subject.valid?
    assert_equal [:family], @subject.errors.keys
  end

  test 'a family can only have one precheck email token at a time' do
    create(:precheck_email_token, family: @family)

    @subject = PrecheckEmailToken.new(family: @family)
    refute @subject.valid?
    assert_equal ["Family already has a precheck email token"], @subject.errors.messages[:family]
  end
end
