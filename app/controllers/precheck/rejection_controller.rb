class Precheck::RejectionController < PrecheckController
  def create
    @family.update!(precheck_status: :changes_requested)
    UpdatedFamilyPrecheckStatusService.new(family: @family).call
    PrecheckMailer.changes_requested(@family, params['message']).deliver_now
  end
end
