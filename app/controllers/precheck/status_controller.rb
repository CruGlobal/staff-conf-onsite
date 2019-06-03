class Precheck::StatusController < PrecheckController
  def show
    @finances = FamilyFinances::Report.call(family: @family)
    @policy = build_policy
  end

  private

  def build_policy
    Pundit.policy(User.new(role: 'finance'), @family)
  end
end
