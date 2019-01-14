class PrecheckEmailsController < ApplicationController
  before_action :find_token, only: %i[new reject]

  def new
    render 'error' and return unless @token

    @family = @token.family
  end

  def reject
    render 'error' and return unless @token

    family = @token.family
    message = params['message']

    if PrecheckMailer.changes_requested(family, message).deliver_now
      @token.delete
    end
    redirect_to precheck_email_rejected_path
  end

  def rejected; end

  private

  def find_token
    return unless params['auth_token']

    @token = PrecheckEmailToken.where(token: params['auth_token']).first
  end
end
