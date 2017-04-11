module Import
  # == Context Input
  #
  # [+context.person+ [+::Person+]]
  # [+context.import+ [+Import::Person+]]
  class UpdatePersonFromImport
    include Interactor

    before do
      @person = context.person
      @import = context.import
    end

    def call
      set_common_attributes
      set_attendee_attributes if @person.is_a?(Attendee)
      set_child_attributes if @person.is_a?(Child)
    rescue StandardError => e
      context.fail!(message: e.message)
    end

    private

    def set_common_attributes
      @person.assign_attributes(
        first_name: @import.first_name,
        last_name: @import.last_name,
        name_tag_first_name: @import.name_tag_first_name,
        name_tag_last_name: @import.name_tag_last_name,
        gender: @import.gender,
        birthdate: @import.birthdate,
        personal_comment: @import.personal_comment,
        arrived_at: @import.arrived_at,
        departed_at: @import.departed_at,
        rec_center_pass_started_at: @import.rec_center_pass_started_at,
        rec_center_pass_expired_at: @import.rec_center_pass_expired_at
      )
    end

    def set_attendee_attributes
      @person.assign_attributes(
        tshirt_size: @import.tshirt_size,
        mobility_comment: @import.mobility_comment,
        phone: @import.phone,
        email: @import.email,
        conference_comment: @import.conference_comment,
        ibs_comment: @import.ibs_comment,
        conference_status: @import.conference_status
      )

      set_human_resource_attributes
      set_attendee_associations
    end

    # TODO: We don't use these attributes in this application, we just hold on
    #       to them to include in future reports
    def set_human_resource_attributes
      @person.assign_attributes(
        ethnicity: @import.ethnicity,
        hired_at: @import.hired_at,
        employee_status: @import.employee_status,
        caring_department: @import.caring_department,
        strategy: @import.strategy,
        assignment_length: @import.assignment_length,
        pay_chartfield: @import.pay_chartfield,
        conference_status: @import.conference_status
      )
    end

    def set_attendee_associations
      @person.conferences = find_conferences(@import.conference_choices)
      @person.courses = find_courses(@import.ibs_courses)
      @person.ministry = find_ministry(@import.ministry_code)
    end

    def find_conferences(choices)
      return [] unless choices.present?

      choices.split(/\s*,\s*/).map do |name|
        begin
          Conference.find_by!(name: name)
        rescue ActiveRecord::ActiveRecordError
          raise format('Could not find Conference, %p', name)
        end
      end
    end

    def find_courses(courses)
      return [] unless courses.present?

      courses.split(/\s*,\s*/).map do |name|
        begin
          Course.find_by!(name: name)
        rescue ActiveRecord::ActiveRecordError
          raise format('Could not find Class, %p', name)
        end
      end
    end

    def find_ministry(code)
      Ministry.find_by(code: code) if code.present?
    end

    def set_child_attributes
      @person.assign_attributes(
        needs_bed: @import.needs_bed,
        grade_level: @import.grade_level,
        childcare_deposit: @import.childcare_deposit,
        childcare_comment: @import.childcare_comment
      )

      @person.childcare_weeks = childcare_weeks(@import.childcare_weeks)
      @person.hot_lunch_weeks = childcare_weeks(@import.hot_lunch_weeks)
    end

    def childcare_weeks(weeks)
      # "SC" is short for "Staff Conference", the last week
      corrected_names =
        (weeks || '').split(/\s*,\s*/).map do |week|
          week == 'SC' ? Childcare::CHILDCARE_WEEKS.last : week
        end

      corrected_names.map { |name| Childcare::CHILDCARE_WEEKS.index(name) }
    end
  end
end
