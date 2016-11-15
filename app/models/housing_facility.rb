class HousingFacility < ApplicationRecord
  has_paper_trail

  has_many :housing_units, dependent: :destroy

  def audit_name
    "#{super}: #{name}"
  end
end
