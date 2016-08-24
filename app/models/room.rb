class Room < ApplicationRecord
  belongs_to :housing_facility

  validates :number, uniqueness: { scope: :housing_facility_id, message:
   'should be unique per facility' }
end
