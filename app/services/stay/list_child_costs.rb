# This service returns a list of symbols indicating which charges apply to a
# given child. The list of symbols returned will all be method names of
# {CostCodeCharge}, so they can be passed to such an object to obtain the
# actual dollar amounts.
#
# == Context Input
#
# [+context.child+ [+Child+]]
# [+context.single_occupancy+ [+Boolean+]]
#   if the person has opted to take an entire dormitory room for themselves
class Stay::ListChildCosts < ApplicationService
  attr_accessor :child, :costs, :single_occupancy, :stay

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
      case
      when child.age >= 18
        :adult
      when child.age >= 11
        :teen
      when child.age >= 5
        stay.needs_bed? ? :child : :child_meal
      else
        stay.needs_bed? ? :infant : nil
      end
  end
end
