# == Context Input
#
# [+context.family+ [+Family+]]
# [+context.housing_type+ [+#to_s+]]
#   An optional {Stay#housing_type} to filter by
class Stay::SumFamilyAttendeesCost
  include Interactor

  before do
    context.subtotal = Money.empty
    context.total = Money.empty
    context.total_adjustments = Money.empty
  end

  def call
    context.family.attendees.each do |attendee|
      result = Stay::ChargeAttendee.call(attendee: attendee,
                                         housing_type: context.housing_type)

      if result.success?
        add_to_context(result)
      else
        context.fail!(error: result.error)
      end
    end
  end

  def add_to_context(result)
    context.total_adjustments += result.total_adjustments
    context.subtotal += result.subtotal
    context.total += result.total
  end
end
