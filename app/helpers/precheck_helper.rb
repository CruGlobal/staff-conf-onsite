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

  def precheck_eligibility_error_label(error, family)
    {
      not_checked_in_already?: 'Already checked-in',
      not_changes_requested_status?: 'Changes are requested',
      not_too_late?: 'Too late for PreCheck',
      not_too_early?: 'Too early for PreCheck',
      housing_preference_confirmed?: 'Housing assignment incomplete',
      chargeable_staff_number_or_zero_balance?: 'Balance due',
      children_forms_approved?: "Childcare forms not yet approved (#{names_of_children_without_approved_forms(family)})"
    }[error.to_sym]
  end

  def names_of_children_without_approved_forms(family)
    PrecheckEligibilityService.new(family: family).children_without_approved_forms.map(&:full_name).to_sentence
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
