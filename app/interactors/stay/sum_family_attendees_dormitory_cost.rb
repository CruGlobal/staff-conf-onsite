# == Context Input
#
# [+context.family+ [+Family+]]
class Stay::SumFamilyAttendeesDormitoryCost
  include Interactor

  def call
    @context = Stay::SumFamilyAttendeesCost.call(family: context.family,
                                                 housing_type: 'dormitory')
  end
end
