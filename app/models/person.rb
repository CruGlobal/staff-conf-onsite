class Person < ApplicationRecord
  belongs_to :family
  belongs_to :ministry

  def full_name
    "#{first_name} #{last_name}"
  end
end
