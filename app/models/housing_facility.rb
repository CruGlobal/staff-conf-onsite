class HousingFacility < ApplicationRecord
  enum housing_type: [:dormitory, :apartment, :self_provided]

  has_many :rooms, dependent: :destroy
end
