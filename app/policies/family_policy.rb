# The security policy for accessing {Family} records.
class FamilyPolicy < GeneralPolicy
  def import?
    user.admin?
  end

  def show_finances?
    true
  end

  def checkin?
    true
  end

  def destroy?
    user.admin? || user.finance?
  end
end
