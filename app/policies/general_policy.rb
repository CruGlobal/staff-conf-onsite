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
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def scope
    true
  end
end
