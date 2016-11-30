class Child < Person
  include FamilyMember

  GRADE_LEVELS = %w(
    age0 age1 age2 age3 age4 age5 grade1 grade2 grade3 grade4 grade5 grade6
    grade7 grade8 grade9 grade10 grade11 grade12 grade13
  ).freeze

  belongs_to :family
  belongs_to :childcare

  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, presence: true
  validates :grade_level, inclusion: { in: GRADE_LEVELS }, allow_nil: true

  # @return [Array<Fixnum>] a list of indexes from the
  #   {Childcare::CHILDCARE_WEEKS} array
  def childcare_weeks
    if (week = self[:childcare_weeks])
      week.split(',').map(&:to_i)
    end
  end

  # @param arr [Array<Fixnum>] a subset of indexes from the
  #   {Childcare::CHILDCARE_WEEKS} array
  def childcare_weeks=(arr)
    arr ||= []
    self[:childcare_weeks] = arr && arr.select(&:present?).sort.join(',')
  end
end
