# This service returns a list of symbols indicating which charges apply to a
# given child. The list of symbols returned will all be method names of
# {CostCodeCharge}, so they can be passed to such an object to obtain the
# actual dollar amounts.
class Stay::ListChildCosts < ApplicationService
  attr_accessor :child

  attr_accessor :costs

  # +Boolean+
  #   if the person has opted to take an entire dormitory room for themselves
  attr_accessor :single_occupancy

  # - Use "ADULT $/DAY" column if child's age is >=15 years old
  # - Use "TEEN $/DAY" column if child's age is >= 11 and < 15 years old
  # - Use "CHILD $/DAY" column if (child's age is >= 5 < 11 years old AND "Needs
  #   Bed" = YES)
  # - Use "INFANT $/DAY" column if (child's age is <5 years old AND "Needs Bed"
  #   = YES)
  # - Use "CHILD MEAL ONLY $/DAY" if (child'd age is <11 and "Needs Bed" = NO)
  def call
    self.costs = append_costs(child)
  end

  private

  def append_costs(child, costs = [])
    costs << :single_delta if single_occupancy

    costs <<
      if child.age >= 18
        :adult
      elsif child.age >= 11
        :teen
      elsif child.needs_bed?
        child.age >= 5 ? :child : :infant
      else
        :child_meal
      end
  end
end
