# == Context Input
#
# [+context.attendee+ [+Attendee+]]
class Stay::ChargeAttendeeApartment
  include Interactor

  def call
    @context = Stay::ChargeAttendee.call(attendee: context.attendee,
                                         housing_type: 'apartment')
  end
end
