class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def audit_name
    "#{self.class.name} ##{id}"
  end
end
