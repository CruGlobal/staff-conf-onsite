class Precheck::RejectionController < PrecheckController
  def create
    redirect_to precheck_status_path and return if inelegible_for_precheck?

    @family.update!(precheck_status: :changes_requested)
    @message = params['message']
    UpdatedFamilyPrecheckStatusService.new(family: @family, message: @message).call
  end

  private

  def inelegible_for_precheck?
    elegibility_checker = PrecheckEligibilityService.new(family: @family)
    elegibility_checker.too_late? || elegibility_checker.checked_in_already?
  end
end
