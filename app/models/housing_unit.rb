class HousingUnit < ApplicationRecord
  belongs_to :housing_facility
  has_many :stays, dependent: :restrict_with_exception
  has_many :people, through: :stays

  validates :housing_facility_id, presence: true
  validates :name, uniqueness: { scope: :housing_facility_id, message:
   'should be unique per facility' }

  scope :natural_order_asc, -> { order(natural_order) }
  scope :natural_order_desc, -> { order(natural_order(:desc)) }

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

  # @return <String> SQL representing the ORDER BY part of a query. This order
  #   attempts to sort the unit's names "naturally". That means we sort the text
  #   part of the name as text and the numeric part as a number. ex: "C99" comes
  #   before "C100"
  def self.natural_order(dir = 'asc')
    nulls = dir.to_s == 'asc' ? 'FIRST' : 'LAST'
    pattern =
      [
        'substring(name, \'^\D+\') %<dir>s NULLS %<nulls>s',
        'substring(name, \'\d+\')::int %<dir>s NULLS %<nulls>s',
        'name %<dir>s'
      ].join(', ')

    format(pattern, dir: dir, nulls: nulls)
  end
end
