class Family < ApplicationRecord
  has_many :people, dependent: :destroy
  has_many :attendees
  has_many :children
  has_one :housing_preference, autosave: true

  accepts_nested_attributes_for :housing_preference

  def to_s
    PersonHelper.family_name(self)
  end
end
