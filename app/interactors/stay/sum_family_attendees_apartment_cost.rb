# == Context Input
#
# [+context.family+ [+Family+]]
class Stay::SumFamilyAttendeesApartmentCost
  include Interactor

  def call
    @context = Stay::SumFamilyAttendeesCost.call(family: context.family,
                                                 housing_type: 'apartment')
  end
end
