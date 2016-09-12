class HousingFacility < ApplicationRecord
  has_many :rooms, dependent: :destroy
end
