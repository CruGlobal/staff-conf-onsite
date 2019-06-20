class PrecheckController < ApplicationController
  layout 'precheck'

  skip_before_action :verify_authenticity_token, :authenticate_user!

  before_action :load_token, :load_family

  rescue_from(ActiveRecord::RecordNotFound) do |_exception|
    render 'error'
  end

  private

  def load_token
    @token = PrecheckEmailToken.find(params['token'])
  end

  def load_family
    @family = @token.family
  end
end
