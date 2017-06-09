class Family < ApplicationRecord
  include PersonHelper

  has_paper_trail

  has_many :people, dependent: :destroy
  has_many :attendees
  has_many :children
  has_many :payments
  has_one :housing_preference, autosave: true, dependent: :destroy,
                               inverse_of: :family
  has_one :chargeable_staff_number, primary_key: :staff_number,
                                    foreign_key: :staff_number
  belongs_to :primary_person, class_name: 'Person',
                              foreign_key: :primary_person_id

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

  def cost_adjustments
    people.flat_map(&:cost_adjustments)
  end

  def check_in!
    self.class.transaction { attendees.each(&:check_in!) }
    FamilyMailer.summary(self).deliver_now
  end

  def checked_in?
    attendees.any? && attendees.all?(&:checked_in?)
  end

  private

  def remove_blank_housing_preference
    if housing_preference && housing_preference.housing_type.blank?
      self.housing_preference = nil
    end
  end
end
