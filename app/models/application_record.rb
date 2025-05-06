class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # @return [String] the description of this record for the audit table (ie:
  #   the table of record versions)
  def audit_name
    "#{self.class.name} #{audit_id}"
  end

  private

  def audit_id
    new_record? ? '(new)' : "##{id}"
  end

  # Define global blacklist for sensitive fields
  RANSACK_EXCLUDED_FIELDS = %w[
    encrypted_password password_reset_token reset_password_token
    confirmation_token token api_key access_token
  ].freeze

  # Automatically allow all safe attributes
  def self.ransackable_attributes(auth_object = nil)
    column_names - RANSACK_EXCLUDED_FIELDS
  end

  def self.ransackable_associations(auth_object = nil)
    reflect_on_all_associations.map(&:name).map(&:to_s)
  end
end
