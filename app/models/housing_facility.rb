class HousingFacility < ApplicationRecord
  has_paper_trail

  enum housing_type: [:dormitory, :apartment, :self_provided]

  belongs_to :cost_code
  has_many :housing_units, dependent: :destroy

  validates :cost_code, presence: true

  delegate :min_days, :max_days, to: :cost_code

  def audit_name
    "#{super}: #{name}"
  end
end
