class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # @return [String] the description of this record for the audit table (ie:
  #   the table of record versions)
  def audit_name
    "#{self.class.name} ##{id}"
  end
end
