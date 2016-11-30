class HousingUnit < ApplicationRecord
  belongs_to :housing_facility
  has_many :stays

  validates :name, uniqueness: { scope: :housing_facility_id, message:
   'should be unique per facility' }

  def self.hierarchy
    hierarchy = {}

    facilities = HousingFacility.all.includes(:housing_units).order(:name)
    facilities.each do |facility|
      type = facility.housing_type.titleize
      hierarchy[type] ||= {}
      hierarchy[type][facility] = facility.housing_units
    end

    hierarchy
  end
end
