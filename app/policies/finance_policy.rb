# Policy classes that extend this one will only allow Finance and Admin users
# to Create, Update, or Destroy records. General users will still be able to
# read these records.
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
