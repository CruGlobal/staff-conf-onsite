# Policy classes that extend this one will only allow all users to Create,
# Update, Read, or Destroy records.
class GeneralPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    !user.read_only?
  end

  def update?
    !user.read_only?
  end

  def destroy?
    !user.read_only?
  end

  def scope
    true
  end
end
