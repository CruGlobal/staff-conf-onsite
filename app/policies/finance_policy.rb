# Finance and Admin users can Create, Read, Update, or Destroy records
class FinancePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.finance? || user.admin?
  end

  def update?
    user.finance? || user.admin?
  end

  def destroy?
    user.finance? || user.admin?
  end

  def scope
    record.class
  end
end
