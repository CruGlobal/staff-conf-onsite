class CostAdjustment < ApplicationRecord
  include Monetizable

  monetize_attr :price_cents, numericality: {
    greater_than_or_equal_to: -1_000_000,
    less_than_or_equal_to:     1_000_000
  }

  # MPD is "Ministry Partner Development"
  enum cost_type: [
    :dorm_adult, :dorm_child, :apartment_rent, :facility_use, :tuition_class,
    :tuition_mpd, :tuition_track, :tuition_staff, :books
  ]

  belongs_to :person, foreign_key: 'person_id'
end
