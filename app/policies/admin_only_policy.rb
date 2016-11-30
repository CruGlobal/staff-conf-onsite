# Policy classes that extend this one will only allow Admin users to Create,
# Update, or Destroy records. Finance and General users will still be able to
# read these records.
class AdminOnlyPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def scope
    record.class
  end
end
