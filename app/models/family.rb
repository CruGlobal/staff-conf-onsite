class Family < ApplicationRecord
  has_paper_trail

  has_many :people, dependent: :destroy
  has_many :attendees
  has_many :children
  has_one :housing_preference, autosave: true

  accepts_nested_attributes_for :housing_preference

  validates :last_name, :staff_number, presence: true

  def to_s
    PersonHelper.family_label(self)
  end

  def audit_name
    "#{super}: #{PersonHelper.family_label(self)}"
  end
end
