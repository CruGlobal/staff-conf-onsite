class Course < ApplicationRecord
  has_paper_trail

  include Monetizable

  monetize_attr :price_cents, numericality: {
    greater_than_or_equal_to: -1_000_000,
    less_than_or_equal_to:     1_000_000
  }

  has_many :course_attendances, dependent: :destroy
  has_many :attendees, through: :course_attendances

  validates :name, :instructor, :week_descriptor, :ibs_code, :location,
            presence: true

  def to_s
    name
  end

  def audit_name
    "#{super}: #{to_s}"
  end
end
