class HousingUnit < ApplicationRecord
  belongs_to :housing_facility

  validates :name, uniqueness: { scope: :housing_facility_id, message:
   'should be unique per facility' }
end
