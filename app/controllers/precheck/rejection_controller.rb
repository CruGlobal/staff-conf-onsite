class Precheck::RejectionController < PrecheckController
  def create
    redirect_to precheck_status_path and return if PrecheckEligibilityService.new(family: @family).too_late?

    @family.update!(precheck_status: :changes_requested)
    @message = params['message']
    UpdatedFamilyPrecheckStatusService.new(family: @family, message: @message).call
  end
end
