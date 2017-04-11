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
    Seminary.find_or_create_by(code: 'IBS') do |seminary|
      seminary.name = 'IBS'
      seminary.code = 'IBS'
      seminary.course_price = 0
    end
  end
end
