class Precheck::ConfirmationController < PrecheckController
  def create
    @family.update!(precheck_status: :approved)
    UpdatedFamilyPrecheckStatusService.new(family: @family).call
  end
end
