class Stay < ApplicationRecord
  HOUSING_TYPE_FIELDS = {
    single_occupancy: [:dormitory].freeze,
    no_charge: [:apartment].freeze,
    waive_minimum: [:apartment].freeze,
    percentage: [:apartment].freeze
  }.freeze

  belongs_to :housing_unit

  validates :person_id, :arrived_at, :departed_at, presence: true
  validates :percentage, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  belongs_to :person
  belongs_to :housing_unit

  def housing_type
    type = housing_unit.try(:housing_facility).try(:housing_type)
    type || :self_provided
  end
end
