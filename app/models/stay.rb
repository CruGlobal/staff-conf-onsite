class Stay < ApplicationRecord
  HOUSING_TYPE_FIELDS = {
    single_occupancy: [:dormitory].freeze,
    no_charge: [:apartment].freeze,
    waive_minimum: [:apartment].freeze,
    percentage: [:apartment].freeze
  }.freeze

  belongs_to :person
  belongs_to :housing_unit

  validates :person_id, :arrived_at, :departed_at, presence: true
  validates :percentage, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }

  def housing_type
    type = housing_facility.try(:housing_type)
    type || :self_provided
  end

  def housing_facility
    # housing_unit will be nil if housing_type == :self_provided
    housing_unit.try(:housing_facility)
  end

  # @return [Integer] the length of the stay, in days
  def duration
    [(departed_at - arrived_at).to_i, min_days].max
  end

  # @return [Integer] the minimum allowed length of a stay, in days
  def min_days
    housing_facility.try(:min_days) || 1
  end
end
