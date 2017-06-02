module FamilyFinances
  class CreateTable < ApplicationService
    attr_accessor :family

    delegate :staff_number, :chargeable_staff_number?, to: :family

    def attendee_reports
      @attendee_reports ||=
        family.attendees.map { |a| CreateAttendeeReport.call(attendee: a) }
    end

    def children_reports
      @children_reports ||=
        family.children.map { |c| CreateChildReport.call(child: c) }
    end

    def subtotal
      @subtotal ||= begin
        balance = Money.empty
        attendee_reports.each { |r| balance += r.subtotal }
        children_reports.each { |r| balance += r.subtotal }
        balance
      end
    end

    def paid
      family.payments.inject(Money.empty) { |sum, p| sum += p.price }
    end

    def unpaid
      @unpaid ||= subtotal - paid
    end

    def staff_number_balance
      chargeable_staff_number? ? unpaid : Money.empty
    end

    def remaining_balance
      chargeable_staff_number? ? Money.empty : unpaid
    end
  end
end
