class HousingFacility < ApplicationRecord
  # TODO does `number` need to be a field, or can it be calculated from `rooms.size`?
  has_many :rooms
end
