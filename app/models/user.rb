class User < ActiveRecord::Base
  ROLES = %w(general finance admin).freeze

  # Create scope and predicate method for each role. ex:
  # - User.finance.first
  # - @user.finance?
  ROLES.each do |role|
    scope role, -> { where(role: role) }
    define_method("#{role}?") { self.role == role }
  end

  validates :guid, presence: true

  unless Rails.env.test?
    before_validation :fetch_cas_attributes, on: :create
  end

  private

  def fetch_cas_attributes
    if email.present?
      attrs = CasAttributes.new(email).get
      set_cas_attributes(attrs)
    else
      errors.add(:email, 'must be present')
    end
  rescue RestClient::ResourceNotFound
    errors.add(:email, "No account found on #{ENV['CAS_URL']} for #{email}")
  rescue RestClient::Unauthorized
    byebug
  end

  def set_cas_attributes(attrs)
    self.guid = attrs['ssoGuid'] if attrs['ssoGuid'].present?
    self.first_name = attrs['firstName'] if attrs['firstName'].present?
    self.last_name = attrs['lastName'] if attrs['lastName'].present?
  end
end
