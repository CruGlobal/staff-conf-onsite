require 'test_helper'

class PrecheckEligibilityServiceTest < ServiceTestCase
  setup do
    @family = create :family
  end

  test 'initialize' do
    assert_kind_of PrecheckEligibilityService, PrecheckEligibilityService.new(@family)
  end
end
