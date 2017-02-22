class Child < Person
  include FamilyMember

  GRADE_LEVELS = %w(
    age0 age1 age2 age3 age4 age5 grade1 grade2 grade3 grade4 grade5 grade6
    grade7 grade8 grade9 grade10 grade11 grade12 grade13 postHighSchool
  ).freeze

  belongs_to :family
  belongs_to :childcare

  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, presence: true
  validates :grade_level, inclusion: { in: GRADE_LEVELS }, allow_nil: true
  validates :childcare_weeks, if: :post_high_school?, absence: {
    message: 'must be blank when child is Post High School'
  }
  validates_associated :meal_exemptions

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

  # @return [Symbol] the school "age group" this child belongs to.
  #   +:childcare+, +junior_senior+, or +post_high_school+ if they are no longer
  #   in public school
  def age_group
    if grade_level.nil? || grade_level == 'postHighSchool'
      :post_high_school
    elsif GRADE_LEVELS.index(grade_level) <= GRADE_LEVELS.index('grade5')
      :childcare
    else
      :junior_senior
    end
  end

  def post_high_school?
    age_group == :post_high_school
  end
end
