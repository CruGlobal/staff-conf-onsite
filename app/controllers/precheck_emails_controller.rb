# TODO: Mark as pre checked complete on confirm action

class PrecheckEmailsController < ApplicationController
  before_action :find_token, only: %i[new confirm reject]

  def new
    render 'error' and return unless @token

    @family = @token.family
    @finances = FamilyFinances::Report.call(family: @family)
    @policy = build_policy
  end

  def confirm
    render 'error' and return unless @token

    @family = @token.family

    @family.update!(precheck_status: :approved)
    PrecheckMailer.precheck_completed(@family).deliver_now

    redirect_to precheck_email_confirmed_path
  end

  def confirmed; end

  def reject
    render 'error' and return unless @token

    family = @token.family

    family.update!(precheck_status: :changes_requested)
    PrecheckMailer.changes_requested(family, params['message']).deliver_now

    redirect_to precheck_email_rejected_path
  end

  def rejected; end

  private

  def find_token
    return if params['auth_token'].blank?

    @token = PrecheckEmailToken.where(token: params['auth_token']).first
  end

  def build_policy
    Pundit.policy(User.new(role: 'finance'), @family)
  end
end
