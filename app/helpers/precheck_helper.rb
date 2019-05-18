module PrecheckHelper
  def precheck_eligible?(family)
    PrecheckEligibilityService.new(family: family).call
  end

  def precheck_eligibility_errors(family)
    PrecheckEligibilityService.new(family: family).errors
  end

  def precheck_eligibility_actionable_errors(family)
    PrecheckEligibilityService.new(family: family).actionable_errors
  end

  def precheck_eligibility_error_label(error)
    error.to_s.humanize
  end

  def precheck_status_label(arg)
    status = arg.is_a?(Family) ? arg.precheck_status : arg

    {
      approved: 'PreCheck Accepted by Conferee',
      changes_requested: 'Changes Requested by Conferee',
      pending_approval: 'Pending Conferee Acceptance'
    }[status.to_sym]
  end

  def precheck_statuses_select_collection
    Family.precheck_statuses.map do |name, _id|
      [precheck_status_label(name), name]
    end
  end

  def too_late_for_precheck?(family)
    PrecheckEligibilityService.new(family: family).too_late?
  end
end
