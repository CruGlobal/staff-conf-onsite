class Family < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :attendees
  has_many :children

  def to_s
    PersonHelper.family_name(self)
  end
end
