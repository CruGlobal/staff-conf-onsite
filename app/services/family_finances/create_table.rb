module FamilyFinances
  class CreateTable < ApplicationService
    attr_accessor :family

    def call
    end

    def attendee_reports
      family.attendees.map { |a| CreateAttendeeReport.call(attendee: a) }
    end

    def children_reports
      family.children.map { |c| CreateChildReport.call(child: c) }
    end
  end
end
