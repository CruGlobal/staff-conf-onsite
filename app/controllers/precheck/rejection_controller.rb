class Precheck::RejectionController < PrecheckController
  def create
    redirect_to precheck_status_path and return unless PrecheckEligibilityService.new(family: @family).call

    @family.update!(precheck_status: :changes_requested)
    @message = params['message']
    UpdatedFamilyPrecheckStatusService.new(family: @family, message: @message).call
  end
end
