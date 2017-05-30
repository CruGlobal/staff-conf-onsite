module FamilyFinances
  class CreateAttendeeReport < BaseReport
    attr_accessor :attendee

    def cost_reports
      [stays_cost, courses_cost, staff_conference_cost, conferences_cost,
       rec_center_cost]
    end

    def on_campus_stays
      stay_scope.select(&:on_campus?).map(&method(:create_stay_row))
    end

    def off_campus_stays
      stay_scope.reject(&:on_campus?).map(&method(:create_stay_row))
    end

    def stay_adjustments
      stays_cost.total_adjustments
    end

    def campus_facility_use
      # TODO: https://www.pivotaltracker.com/story/show/139317971
    end

    def courses
      course_scope.flat_map(&method(:create_course_row))
    end

    def course_adjustments
      courses_cost.total_adjustments
    end

    def staff_conference
      staff_conference_scope.flat_map(&method(:create_conference_row))
    end

    def staff_conference_adjustments
      staff_conference_cost.total_adjustments
    end

    def conferences
      conference_scope.flat_map(&method(:create_conference_row))
    end

    def conference_adjustments
      conferences_cost.total_adjustments
    end

    def rec_center
      [create_row('Pass', rec_center_cost.total)]
    end

    def rec_center_adjustments
      @rec_center_adjustments ||= rec_center_cost.total_adjustments
    end

    private

    def stay_scope
      attendee.stays.not_in_self_provided
    end

    def create_stay_row(stay)
      create_row(stay.to_s, Stay::SingleAttendeeCost.call(stay: stay).total)
    end

    def course_scope
      attendee.course_attendances
    end

    def create_course_row(attendance)
      course = attendance.course

      seminary =
        if attendance.seminary_credit?
          create_row('Seminary Credit: YES', attendee.seminary.course_price)
        else
          create_row('Seminary Credit: NO', 0)
        end

      [create_row(course.to_s, course.price), seminary]
    end

    def staff_conference_scope
      attendee.conferences.where(staff_conference: true)
    end

    def conference_scope
      attendee.conferences.where(staff_conference: false)
    end

    def create_conference_row(conf)
      create_row(conf.to_s, conf.price)
    end

    def stays_cost
      @stays_cost ||= Stay::ChargeAttendeeCost.call(attendee: attendee)
    end

    def courses_cost
      @courses_cost ||= Course::ChargeAttendeeCost.call(attendee: attendee)
    end

    def staff_conference_cost
      @staff_conference_cost ||=
        StaffConference::ChargeAttendeeCost.call(attendee: attendee)
    end

    def conferences_cost
      @conferences_cost ||=
        Conference::ChargeAttendeeCost.call(attendee: attendee)
    end

    def rec_center_cost
      @rec_center_cost ||= RecPass::ChargePersonCost.call(person: attendee)
    end
  end
end
