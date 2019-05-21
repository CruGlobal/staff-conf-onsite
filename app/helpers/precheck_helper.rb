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
    t("precheck_helper.eligibility_error_label.#{error}", names_of_children: names_of_children_without_approved_forms(family))
  end

  def names_of_children_without_approved_forms(family)
    PrecheckEligibilityService.new(family: family).children_without_approved_forms.map(&:full_name).to_sentence
  end

  def precheck_status_label(arg)
    status = arg.is_a?(Family) ? arg.precheck_status : arg
    t("precheck_helper.status_label.#{status}")
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
