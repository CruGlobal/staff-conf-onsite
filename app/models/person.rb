class Person < ApplicationRecord
  GENDERS = { f: 'Female', m: 'Male' }.freeze

  has_paper_trail

  belongs_to :family
  belongs_to :ministry

  has_many :cost_adjustments
  has_many :meal_exemptions

  validates :family_id, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def audit_name
    "#{super}: #{full_name}"
  end
end
