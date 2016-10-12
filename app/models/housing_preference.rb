class HousingPreference < ApplicationRecord
  enum housing_type: [:dormitory, :apartment, :self_provided]

  belongs_to :family

  validates :family_id, presence: true
end
