class Seminary < ActiveRecord::Base
  has_paper_trail
  
  has_many :attendees

  include Monetizable
  monetize_attr :course_price_cents, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to:    1_000_000
  }

  validates_presence_of :name, :code, :course_price_cents
end
