class PrecheckEligibilityService
  attr_reader :family

  def initialize(family)
    @family = family
  end

  def eligible?
  end
end
