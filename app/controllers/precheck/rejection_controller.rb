class Precheck::RejectionController < PrecheckController
  def create
    @family.update!(precheck_status: :changes_requested)
    @message = params['message']
    UpdatedFamilyPrecheckStatusService.new(family: @family, message: @message).call
  end
end
