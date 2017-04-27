class Stay < ApplicationRecord
  HOUSING_TYPE_FIELDS = {
    single_occupancy: [:dormitory].freeze,
    no_charge: [:apartment].freeze,
    waive_minimum: [:apartment].freeze,
    percentage: [:apartment].freeze
  }.freeze

  belongs_to :person
  belongs_to :housing_unit

  validates :person_id, :arrived_at, :departed_at, presence: true
  validates :percentage, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
  validate :no_more_than_max_days!

  scope :for_date, (lambda do |date|
    where('arrived_at <= ? AND departed_at >= ?', date, date)
  end)

  def housing_type
    type = housing_facility.try(:housing_type)
    type || 'self_provided'
  end

  def housing_facility
    # housing_unit will be nil if housing_type == 'self_provided'
    housing_unit.try(:housing_facility)
  end

  def dormitory?
    housing_type == 'dormitory'
  end

  def on_campus
    housing_facility.present? && housing_facility.on_campus
  end
  alias on_campus? on_campus

  # @return [Integer] the length of the stay, in days
  def duration
    [(departed_at - arrived_at).to_i, min_days].max
  end

  # @return [Integer] if this stay is in a dormitory, the total duration of all
  #   stays in this facility, otherwise the same as {#duration}
  def total_duration
    if housing_type == 'dormitory'
      duration_of_all_dormitory_stays
    else
      duration
    end
  end

  # @return [Integer] the minimum allowed length of a stay, in days
  def min_days
    waive_minimum? ? 1 : (housing_facility.try(:min_days) || 1)
  end

  # @return [Float] the percentage of this stay's cost which must be paid by
  #   the Attendee, expressed as a decimal between 0 and 1.
  def must_pay_ratio
    percentage / 100.0
  end

  private

  def duration_of_all_dormitory_stays
    person.reload.stays.
      select { |s| s.housing_type == 'dormitory' }.
      map(&:duration).
      inject(0, &:+)
  end

  def no_more_than_max_days!
    return if housing_type == 'self_provided'

    all_stays = ([self] + person.reload.stays).uniq(&:id)
    duration = all_stays.map(&:duration).inject(&:+) || 0

    add_max_days_error(duration) if duration > housing_facility.max_days
  end

  def add_max_days_error(duration)
    errors.add(
      :departed_at,
      format('will mean that %s has stayed at this facility for a total of %d' \
             ' days: longer than the maximum allowed (%d) by the cost code, %s',
             person.full_name, duration, housing_facility.max_days,
             housing_facility.cost_code.name)
    )
  end
end
