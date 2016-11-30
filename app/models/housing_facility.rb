class HousingFacility < ApplicationRecord
  has_paper_trail

  enum housing_type: [:dormitory, :apartment, :self_provided]

  belongs_to :cost_code
  has_many :housing_units, dependent: :destroy

  def audit_name
    "#{super}: #{name}"
  end
end
