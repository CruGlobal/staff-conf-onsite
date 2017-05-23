class Family < ApplicationRecord
  include PersonHelper

  has_paper_trail

  has_many :people, dependent: :destroy
  has_many :attendees
  has_many :children
  belongs_to :primary_person, class_name: 'Person', foreign_key: :primary_person_id
  has_one :housing_preference, autosave: true, dependent: :destroy
  has_one :chargeable_staff_number, primary_key: :staff_number,
                                    foreign_key: :staff_number

  accepts_nested_attributes_for :housing_preference
  accepts_nested_attributes_for :people

  validates :last_name, presence: true
  validates_associated :housing_preference

  before_validation :remove_blank_housing_preference

  # @see PersonHelper.family_label
  def to_s
    family_label(self)
  end

  def audit_name
    "#{super}: #{family_label(self)}"
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
