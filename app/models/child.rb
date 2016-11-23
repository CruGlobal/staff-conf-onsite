class Child < Person
  include FamilyMember

  belongs_to :family
  belongs_to :childcare

  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, presence: true

  # @return [Array<Integer>] A list of indexes from the CHILDCARE_WEEKS array
  def childcare_weeks
    if (week = self[:childcare_weeks])
      week.split(',').map(&:to_i)
    end
  end

  # @param [Array<Integer>] arr A list of indexes from the CHILDCARE_WEEKS array
  # @see Childcare#CHILDCARE_WEEKS
  def childcare_weeks=(arr)
    arr ||= []
    self[:childcare_weeks] = arr && arr.select(&:present?).sort.join(',')
  end
end
