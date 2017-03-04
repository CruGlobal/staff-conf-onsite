class HousingFacility < ApplicationRecord
  has_paper_trail

  enum housing_type: [:dormitory, :apartment, :self_provided]

  belongs_to :cost_code
  has_many :housing_units, dependent: :destroy

  # @return [Integer] the minimum allowed length of a stay at this facility, in
  #   days
  def min_days
    cost_code.try(:min_days) || 1
  end

  def audit_name
    "#{super}: #{name}"
  end
end
