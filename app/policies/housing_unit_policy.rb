# The security policy for accessing {HousingUnit} records.
class HousingUnitPolicy < GeneralPolicy
  def create?
    !user.finance?
  end

  def update?
    !user.finance?
  end

  def destroy?
    !user.finance?
  end
end
