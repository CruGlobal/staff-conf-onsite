require 'test_helper'

class PrecheckEmailTokenTest < ModelTestCase
  setup do
    @family = create(:family)
  end

  test 'auto generates a token on initialization' do
    @subject = PrecheckEmailToken.new
    assert @subject.token
  end

  test 'is invalid without a family' do
    @subject = PrecheckEmailToken.new
    refute @subject.valid?
    assert_equal [:family], @subject.errors.attribute_names
  end

  test 'a family can only have one precheck email token at a time' do
    @subject = PrecheckEmailToken.new(family: @family)
    refute @subject.valid?
    assert_equal ["Family already has a precheck email token"], @subject.errors.messages[:family]
  end
end
