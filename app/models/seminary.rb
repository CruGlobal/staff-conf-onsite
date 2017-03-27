class Seminary < ApplicationRecord
  include Monetizable

  has_paper_trail
  
  has_many :attendees

  monetize_attr :course_price_cents, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to:    1_000_000
  }
  validates :name, :code, presence: true

  def audit_name
    "#{super}: #{name}"
  end

  def self.default
    Rails.cache.fetch(:default_seminary, expires_in: 1.week) do
      Seminary.find_by_code('IBS')
    end
  end
end
