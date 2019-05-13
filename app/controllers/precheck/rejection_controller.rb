class Precheck::RejectionController < PrecheckController
  def create
    @family.update!(precheck_status: :changes_requested)
    UpdatedFamilyPrecheckStatusService.new(family: @family, message: message_param).call
  end

  private

  def message_param
    params['message']
  end
end
