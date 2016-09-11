class AdminUser < ActiveRecord::Base
  ROLES = %w(general finance admin).freeze

  # Create scope and predicate method for each role. ex:
  # - AdminUser.finance.first
  # - @admin_user.finance?
  ROLES.each do |role|
    scope role, -> { where(role: role) }
    define_method("#{role}?") { self.role == role }
  end

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
end
