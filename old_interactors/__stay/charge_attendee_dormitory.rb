# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class Stay::ChargeAttendeeDormitory
  include Interactor

  def call
    @context = Stay::ChargeAttendee.call(attendee: context.attendee,
                                         housing_type: 'dormitory')
  end
end
