class Precheck::RejectionController < PrecheckController
  def create
    redirect_to precheck_status_path and return if Precheck::EligibilityService.new(family: @family).too_late_or_checked_in?

    @family.update!(precheck_status: :changes_requested)
    @message = params['message']
    Precheck::UpdatedFamilyStatusService.new(family: @family, message: @message).call
  end
end
