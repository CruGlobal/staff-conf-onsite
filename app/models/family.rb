class Family < ApplicationRecord
  has_paper_trail

  has_many :people, dependent: :destroy
  has_many :attendees
  has_many :children
  has_one :housing_preference, autosave: true
  has_one :chargeable_staff_number, primary_key: :staff_number,
                                    foreign_key: :staff_number

  accepts_nested_attributes_for :housing_preference

  validates :last_name, :staff_number, presence: true

  before_validation :remove_blank_housing_preference

  # @see PersonHelper.family_label
  def to_s
    PersonHelper.family_label(self)
  end

  def audit_name
    "#{super}: #{PersonHelper.family_label(self)}"
  end

  def chargeable_staff_number?
    chargeable_staff_number.present?
  end

  private

  def remove_blank_housing_preference
    if housing_preference && housing_preference.housing_type.blank?
      self.housing_preference = nil
    end
  end
end
