class HousingPreference < ApplicationRecord
  HOUSING_TYPE_FIELDS = {
    roommates: [:dormitory].freeze,
    beds_count: [:dormitory].freeze,
    single_room: [:dormitory].freeze,

    children_count: [:apartment].freeze,
    bedrooms_count: [:apartment].freeze,
    other_family: [:apartment].freeze,
    accepts_non_air_conditioned: [:apartment].freeze,

    location1: [:apartment, :dormitory].freeze,
    location2: [:apartment, :dormitory].freeze,
    location3: [:apartment, :dormitory].freeze
  }.freeze

  enum housing_type: [:dormitory, :apartment, :self_provided]

  belongs_to :family

  validates :family_id, presence: true
end
