class HousingFacility < ApplicationRecord
  has_paper_trail

  enum housing_type: [:dormitory, :apartment, :self_provided]

  has_many :housing_units, dependent: :destroy

  def audit_name
    "#{super}: #{name}"
  end
end
