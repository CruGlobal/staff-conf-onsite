# == Context Input
#
# [+context.person+ [+Person+]]
class RecPass::SumPersonCost
  include Interactor

  before do
    context.charges ||= Hash.new { |h, v| h[v] = Money.empty }
  end

  def call
    context.charges[:rec_center] = applicable? ? rec_center_cost : Money.empty
    context.cost_adjustments = context.person.cost_adjustments
  end

  private

  def applicable?
    start_at.present? && finish_at.present?
  end

  def start_at
    context.person.rec_center_pass_started_at
  end

  def finish_at
    context.person.rec_center_pass_expired_at
  end

  def rec_center_cost
    duration * UserVariable[:rec_center_daily]
  end

  def duration
    (finish_at - start_at).to_i + 1
  end
end
