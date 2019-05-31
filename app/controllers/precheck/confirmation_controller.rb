class Precheck::ConfirmationController < PrecheckController
  def create
    redirect_to precheck_status_path and return unless PrecheckEligibilityService.new(family: @family).call

    @family.update!(precheck_status: :approved)
    UpdatedFamilyPrecheckStatusService.new(family: @family).call
  end
end
