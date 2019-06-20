class Precheck::ConfirmationController < PrecheckController
  def create
    redirect_to precheck_status_path and return unless Precheck::EligibilityService.new(family: @family).call

    @family.update!(precheck_status: :approved)
    Precheck::UpdatedFamilyStatusService.new(family: @family).call
  end
end
