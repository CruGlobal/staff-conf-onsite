class Precheck::RejectionController < PrecheckController
  def create
    @family.update!(precheck_status: :changes_requested)
    PrecheckMailer.changes_requested(@family, params['message']).deliver_now
  end
end
