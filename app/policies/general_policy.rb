# All users can Create, Read, Update, and Destroy records
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
