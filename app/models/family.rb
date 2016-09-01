class Family < ApplicationRecord
  has_many :people
  has_many :attendees
  has_one :spouse
  has_many :children

  def to_s
    PersonHelper.family_name(self)
  end
end
