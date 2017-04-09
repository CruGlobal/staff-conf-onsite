module Import
  class Person
    include ActiveModel::Model

    SPREADSHEET_TITLES = {
      person_type: 'Person Type',
      family_id:   'Family',

      first_name:          'First',
      last_name:           'Last',
      name_tag_first_name: 'Name Tag Name Last',
      name_tag_last_name:  'Name Tag Name First',
      gender:              'Gender',
      staff_number:        'Staff ID',
      birthdate:           'Birthdate',
      age:                 'Age',
      tshirt_size:         'T-Shirt Size',
      ethnicity:           'Ethnicity',

      mobility_comment: 'Mobility Needs Comment',
      personal_comment: 'Personal Comments',

      address1:   'Address 1',
      address2:   'Address 2',
      city:       'City',
      state:      'State',
      zip_code:   'ZIP',
      country:    'Country',
      cell_phone: 'Cell',
      email:      'Email',

      conference_choices: 'Conference Choices',
      conference_comment: 'Conference Comments',

      arrived_at:  'Arrival Date',
      departed_at: 'Departure Date',

      housing_type:              'Housing Type Requested',
      housing_beds_count:        'Total Dorm Beds Requested',
      housing_single_room:       'Single room requested',
      housing_roommates:         'Dorm Requested Roommate',
      housing_roommates_email:   'Dorm Requested Roommate Email',
      housing_children_count:    'Apt Number Of Children',
      housing_size:              'Apt Size Requested',
      housing_sharing_requested: 'Apt Sharing Requested',
      housing_accepts_non_ac:    'Accept NON-A/C Apt',
      housing_location1:         'Housing 1st Choice',
      housing_location2:         'Housing 2nd Choice',
      housing_location3:         'Housing 3rd Choice',
      housing_comments:          'Housing Comments',
      housing_needs_bed:         'Child Needs Dorm Bed',

      age_group:          'Age Group',
      childcare_deposit:  'Childcare Deposit',
      childcare_weeks:    'Child Program Weeks',
      hot_lunch_weeks:    'Hot Lunch Weeks',
      childcare_comments: 'Childcare Comments',

      ibs_courses:  'IBS Courses',
      ibs_comments: 'IBS Comments',

      rec_center_pass_started_at: 'RecPass Start Date',
      rec_center_pass_expired_at: 'RecPass End Date',

      ministry_code:     'Ministry Code',
      hire_date:         'Hire Date',
      employee_status:   'Employee Status',
      caring_department: 'Caring Department',
      strategy:          'Strategy',
      assignment_length: 'Assignment Length',
      pay_chartfield:    'Pay Chartfield',
      conference_status: 'Conference Status'
    }.freeze

    attr_accessor(*SPREADSHEET_TITLES.keys)

    PERSON_TYPES = {
      'Primary' => Attendee,
      'Spouse' => Attendee,
      'Child' => Child,
      'Additional Family Member' => Child
    }.freeze

    # @return [Boolean] if this person holds the family/address details for
    # their family
    def primary_family_member?
      person_type == 'Primary'
    end

    # @return [ApplicationRecord] the record class which this imported person
    #   represents
    def record_class
      PERSON_TYPES[person_type] || Child
    end
  end
end
