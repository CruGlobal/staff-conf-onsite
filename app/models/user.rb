class User < ApplicationRecord
  # The possible values of the +role+ attribute.
  ROLES = %w(general finance admin).freeze

  # Create scope and predicate method for each role. ex:
  # - +User.finance.first+
  # - +@user.finance?+
  ROLES.each do |r|
    scope(r, -> { where(role: r) })
    define_method("#{r}?") { role == r }
  end

  has_many :upload_jobs

  validates :guid, presence: true
  validates :role, inclusion: { in: ROLES }

  before_validation :fetch_cas_attributes, on: :create unless Rails.env.test?

  private

  def fetch_cas_attributes
    if email.present?
      attrs = CasAttributes.new(email).get
      self.cas_attributes = attrs
    else
      errors.add(:email, 'must be present')
    end
  rescue RestClient::ResourceNotFound
    errors.add(:email, "No account found on #{ENV['CAS_URL']} for #{email}")
  end

  def cas_attributes=(attrs)
    self.guid = attrs['ssoGuid'] if attrs['ssoGuid'].present?
    self.first_name = attrs['firstName'] if attrs['firstName'].present?
    self.last_name = attrs['lastName'] if attrs['lastName'].present?
  end
end
