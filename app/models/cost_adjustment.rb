class CostAdjustment < ApplicationRecord
  include Monetizable

  monetize_attr :price_cents, numericality: {
    greater_than_or_equal_to: -1_000_000,
    less_than_or_equal_to:     1_000_000
  }

  belongs_to :person, foreign_key: 'person_id'
end
