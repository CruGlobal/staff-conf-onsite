# rubocop:disable Metrics/ClassLength
class Child < Person
  include FamilyMember

  GRADE_LEVELS = %w[
    age0 age1 age2 age3 age4 age5-kindergarten
    grade1 grade2 grade3 grade4 grade5 grade6 grade7 grade8 grade9
    grade10 grade11 grade12 grade13 postHighSchool
  ].freeze

  belongs_to :family, optional: true
  belongs_to :childcare, optional: true
  has_one :primary_person, through: :family, source: :primary_person
  # has_many :conferences, through: :primary_person, source: :conferences
  has_many :childcare_envelopes, dependent: :destroy
  has_one :childcare_medical_history, dependent: :destroy
  has_one :cru_student_medical_history, dependent: :destroy

  accepts_nested_attributes_for :childcare_medical_history
  accepts_nested_attributes_for :cru_student_medical_history

  scope :in_kidscare, (lambda do
    where(['childcare_weeks is NOT NULL', "childcare_weeks <> ''",
           'grade_level IN(?)'].join(' AND '), childcare_grade_levels)
  end)

  after_commit :send_forms_approved_email, if: proc { |object| object.previous_changes.include?('forms_approved') }

  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, presence: true
  validates :grade_level, inclusion: { in: GRADE_LEVELS }, allow_nil: true
  validates :childcare_weeks, if: :post_high_school?, absence: {
    message: 'must be blank when child is Post High School'
  }
  validates :childcare, if: :too_old_for_childcare?, absence: {
    message: 'must be blank when child is older than Grade 5'
  }
  validates :forms_approved_by, presence: true, if: :forms_approved?
  validates :forms_approved_by, absence: true, unless: :forms_approved?
  validates_associated :meal_exemptions
  validate :hot_lunch_weeks_must_match_childcare_weeks!
  validate :hot_lunch_age_range!

  class << self
    def childcare_grade_levels
      GRADE_LEVELS.first(grade6_index + 1)
    end

    def childcare_care_grade_levels
      GRADE_LEVELS.first(gradeAge5Kindergarten_index + 1)
    end
    
    def childcare_camp_grade_levels
      (GRADE_LEVELS.first(grade6_index + 1) - GRADE_LEVELS.first(gradeAge5Kindergarten_index))
    end

    def hot_lunch_grade_levels
      (GRADE_LEVELS.first(grade13_index + 1) - GRADE_LEVELS.first(age1_index + 1))
    end

    def senior_grade_levels
      GRADE_LEVELS.last(GRADE_LEVELS.size - (grade6_index + 1))
    end

    def grade5_index
      GRADE_LEVELS.index('grade5')
    end

    def grade6_index
      GRADE_LEVELS.index('grade6')
    end

    def gradeAge5Kindergarten_index
      GRADE_LEVELS.index('age5-kindergarten')
    end

    def grade13_index
      GRADE_LEVELS.index('grade13')
    end

    def age1_index
      GRADE_LEVELS.index('age1')
    end

    def kids_care_grades
      GRADE_LEVELS.first(gradeAge5Kindergarten_index + 1)
    end

    def kids_camp_grades
      GRADE_LEVELS[grade1_index..grade6_index]
    end

    def grade1_index
      GRADE_LEVELS.index('grade1')
    end
  end

  def childcare_care_grade?
    self.class.childcare_care_grade_levels.include?(grade_level)
  end

  def childcare_camp_grade?
    self.class.childcare_camp_grade_levels.include?(grade_level)
  end

  def crustu_grade?
    self.class.senior_grade_levels.include?(grade_level)
  end

  def conferences
    family.attendees.collect(&:conferences).flatten.uniq
  end

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
    self[:childcare_weeks] = arr&.select(&:present?)&.sort&.join(',')
  end

  # @return [Symbol] the school "age group" this child belongs to.
  #   +:childcare+, +junior_senior+, or +post_high_school+ if they are no longer
  #   in public school
  def age_group
    if grade_level.nil? || grade_level == 'postHighSchool'
      :post_high_school
    elsif self.class.childcare_grade_levels.include?(grade_level)
      :childcare
    else
      :junior_senior
    end
  end

  def post_high_school?
    age_group == :post_high_school
  end

  def too_old_for_childcare?
    age_group != :childcare
  end

  # @return [Array<Fixnum>] a list of indexes from the
  #   {Childcare::CHILDCARE_WEEKS} array in which the child is getting a hot
  #   lunch
  def hot_lunch_weeks
    if (week = self[:hot_lunch_weeks])
      week.split(',').map(&:to_i)
    end
  end

  # @param arr [Array<Fixnum>] a subset of indexes from the
  #   {Childcare::CHILDCARE_WEEKS} array in which the child is getting a hot
  #   lunch
  def hot_lunch_weeks=(arr)
    arr ||= []
    self[:hot_lunch_weeks] = arr&.select(&:present?)&.sort&.join(',')
  end

  # @return [Array<Date>] the days this child is paying for a hot lunch
  def hot_lunch_dates
    start_dates =
      hot_lunch_weeks.map do |week_offset|
        UserVariable["hot_lunch_begin_#{week_offset}"]
      end

    start_dates.flat_map do |date|
      Array.new(7) { |idx| date + idx.days }
    end
  end

  def completed_envelope?
    childcare_envelopes.pluck(:status).include?(ChildcareEnvelope::COMPLETED_ENVELOPE_STATUS)
  end

  def pending_envelope?
    childcare_envelopes.pluck(:status).any? { |s| ChildcareEnvelope::IN_PROCESS_ENVELOPE_STATUSES.include?(s) }
  end

  private

  def hot_lunch_weeks_must_match_childcare_weeks!
    if hot_lunch_weeks.any? { |week| !childcare_weeks.include?(week) }
      errors.add(:hot_lunch_weeks, 'can only include Weeks of ChildCare')
    end
  end

  def hot_lunch_age_range!
    if hot_lunch_weeks.any? && (!self.class.hot_lunch_grade_levels.include?(grade_level))
      errors.add(:hot_lunch_weeks, 'is only for children at least 2 years old and in' \
                                   ' grade 13 or lower')
    end
  end

  # def hot_lunch_age_range!
  #   if hot_lunch_weeks.any? && (age_group != :childcare || age <= 2)
  #     errors.add(:hot_lunch_weeks, 'is only for children at least 3 years old and in' \
  #                                  ' grade 5 or lower')
  #   end
  # end

  def send_forms_approved_email
    if forms_approved?
      FamilyMailer.forms_approved(family, self).deliver_now
    end
  end
end
# rubocop:enable Metrics/ClassLength
