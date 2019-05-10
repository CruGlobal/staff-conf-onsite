module PrecheckHelper
  def precheck_eligible?(family)
    PrecheckEligibilityService.new(family: family).call
  end

  def precheck_eligibility_errors(family)
    PrecheckEligibilityService.new(family: family).reportable_errors
  end

  def precheck_status_label(arg)
    status = arg.is_a?(Family) ? arg.precheck_status : arg
    status.titleize
  end

  def precheck_statuses_select_collection
    Family.precheck_statuses.map do |name, _id|
      [precheck_status_label(name), name]
    end
  end
end
