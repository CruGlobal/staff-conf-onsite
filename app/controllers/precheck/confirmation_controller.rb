class Precheck::ConfirmationController < PrecheckController
  def create
    @family.update!(precheck_status: :approved)
  end
end
