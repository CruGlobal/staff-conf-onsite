class Payment < ApplicationRecord
  include Monetizable

  has_paper_trail

  monetize_attr :price_cents, numericality: {
    greater_than_or_equal_to: -1_000_000,
    less_than_or_equal_to:     1_000_000
  }

  enum cost_type: CostAdjustment.cost_types.keys

  belongs_to :family

  validates :family_id, :cost_type, :price_cents, presence: true
end
