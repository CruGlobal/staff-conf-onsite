class Child < Person
  include FamilyMember

  belongs_to :family
  belongs_to :childcare

  accepts_nested_attributes_for :meal_exemptions, allow_destroy: true

  validates :family_id, presence: true

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
