class User < ApplicationRecord
  # The possible values of the +role+ attribute.
  ROLES = %w[general finance admin read_only].freeze

  # Create scope and predicate method for each role. ex:
  # - +User.finance.first+
  # - +@user.finance?+
  ROLES.each do |r|
    scope(r, -> { where(role: r) })
    define_method("#{r}?") { role == r }
  end

  has_many :upload_jobs, dependent: :destroy

  validates :email, presence: true
  validates :role, inclusion: { in: ROLES }

  def full_name
    [first_name, last_name].compact.join(' ')
  end
end
