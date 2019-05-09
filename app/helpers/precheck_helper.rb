module PrecheckHelper
  def precheck_eligible?(family)
    PrecheckEligibilityService.new(family: family).call
  end
end
