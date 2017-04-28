# The security policy for accessing {Family} records.
class FamilyPolicy < GeneralPolicy
  def import?
    user.admin?
  end
end
