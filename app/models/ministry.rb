class Ministry < ApplicationRecord
  has_paper_trail

  has_many :people

  def audit_name
    "#{super}: #{name}"
  end
end
