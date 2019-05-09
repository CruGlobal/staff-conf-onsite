class Precheck::ConfirmationController < PrecheckController
  def create
    @family.update!(precheck_status: :approved)
    PrecheckMailer.precheck_completed(@family).deliver_now
  end
end
