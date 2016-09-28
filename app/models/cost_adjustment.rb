class CostAdjustment < ActiveRecord::Base
  monetize :price_cents

  belongs_to :person, foreign_key: 'person_id'
end
