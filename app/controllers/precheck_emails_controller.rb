class PrecheckEmailsController < ApplicationController
  before_action :find_token, only: %i[new]

  def new
    render 'error' and return unless @token

    @family = @token.family
  end

  private

  def find_token
    return unless params['auth_token']

    @token = PrecheckEmailToken.where(token: params['auth_token']).first
  end
end
