# TODO: Mark as pre checked complete on confirm action

class PrecheckEmailsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_token, only: %i[new confirm reject]

  def new
    render 'error' and return unless @token

    @family = @token.family
    @finances = FamilyFinances::Report.call(family: @family)
    @policy = Pundit.policy(User.find_by(role: 'finance'), @family)
  end

  def confirm
    render 'error' and return unless @token

    @family = @token.family

    # TODO: Mark as pre checked complete
    PrecheckMailer.precheck_completed(@family).deliver_now

    redirect_to precheck_email_confirmed_path
  end

  def confirmed; end

  def reject
    render 'error' and return unless @token

    family = @token.family
    message = params['message']

    PrecheckMailer.changes_requested(family, message).deliver_now

    redirect_to precheck_email_rejected_path
  end

  def rejected; end

  private

  def find_token
    return if params['auth_token'].blank?

    @token = PrecheckEmailToken.where(token: params['auth_token']).first
  end
end
