class Person < ApplicationRecord
  GENDERS = { f: 'Female', m: 'Male' }.freeze

  belongs_to :family
  belongs_to :ministry

  has_many :cost_adjustments

  def full_name
    "#{first_name} #{last_name}"
  end
end
