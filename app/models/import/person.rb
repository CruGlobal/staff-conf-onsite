module Import
  class Person # rubocop:disable Metrics/ClassLength
    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment

    TRUE_VALUES = defined?(ActiveModel::Type::Boolean::TRUE_VALUES) ?
      ActiveModel::Type::Boolean::TRUE_VALUES :
      [true, 1, '1', 't', 'T', 'true', 'TRUE']

    SPREADSHEET_TITLES = {
      person_type: 'Person Type',
      family_tag: 'Family',
      
      student_number: 'Student Number',
      first_name: 'First',
      child_middle_name: 'Child Middle',
      last_name: 'Last',
      name_tag_first_name: 'Name Tag Name First',
      name_tag_last_name: 'Name Tag Name Last',
      gender: 'Gender',
      staff_number: 'Staff ID',
      birthdate: 'Birthdate',
      age: 'Age',
      tshirt_size: 'T-Shirt Size',
      ethnicity: 'Ethnicity',
    
      mobility_comment: 'Mobility Needs Comment',
      personal_comment: 'Personal Comments',
    
      address1: 'Address 1',
      address2: 'Address 2',
      city: 'City',
      state: 'State',
      zip: 'ZIP',
      county: 'County',
      country: 'Country',
      phone: 'Cell',
      email: 'Email',
    
      conference_choices: 'Conference Choices',
      conference_comment: 'Conference Comments',
    
      arrived_at: 'Arrival Date',
      departed_at: 'Departure Date',
    
      housing_type: 'Housing Type Requested',
      housing_beds_count: 'Total Dorm Beds Requested',
      housing_single_room: 'Single room requested',
      housing_roommates: 'Dorm Requested Roommate',
      housing_roommates_email: 'Dorm Requested Roommate Email',
      housing_children_count: 'Apt Number Of Children',
      housing_bedrooms_count: 'Apt Size Requested',
      housing_sharing_requested: 'Apt Sharing Requested',
      housing_accepts_non_ac: 'Accept NON-A/C Apt',
      housing_location1: 'Housing 1st Choice',
      housing_location2: 'Housing 2nd Choice',
      housing_location3: 'Housing 3rd Choice',
      housing_comment: 'Housing Comments',
    
      grade_level: 'Age Group',
      needs_bed: 'Child Needs Dorm Bed',
      # childcare_deposit: 'Cru Kids Deposit',
      childcare_weeks: 'Child Program Weeks',
      hot_lunch_weeks: 'Hot Lunch Weeks',
      childcare_comment: 'Cru Kids Comments',
    
      ibs_courses: 'IBS Courses',
      ibs_comment: 'IBS Comments',
    
      rec_pass_start_at: 'RecPass Start Date',
      rec_pass_end_at: 'RecPass End Date',
    
      car_license_plate: 'Car License Plate',
      ministry_code: 'Ministry Code',
      hired_at: 'Hire Date',
      employee_status: 'Employee Status',
      caring_department: 'Caring Department',
      strategy: 'Strategy',
      assignment_length: 'Assignment Length',
      pay_chartfield: 'Pay Chartfield',
      tracking_id: 'TrackingID',
      conference_status: 'Conference Status',
      # CC
      allergy: 'Forms CC MH Other Allergy',
      cc_allergies: 'Forms CC MH Allergy Multi',
      cc_medi_allergy: 'Forms CC MH Med Allergy',
      # food_intolerance: 'Forms CC MH Food Intolerance',
      chronic_health: 'Forms CC MH Chronic Health',
      chronic_health_addl: 'Forms CC MH Chronic Health Addl',
      medications: 'Forms CC MH Medications',
      immunizations: 'Forms CC MH Immunizations',
      non_immunizations: 'Forms CC MH non-immunized',
      health_misc: 'Forms CC MH Health Misc',
      restrictions: 'Forms CC MH Restrictions',    
      crustu_forms_acknowledged: 'crustu_forms_acknowledged',
      cc_other_special_needs: 'Forms CC MH Special Needs',

      # CC VIP
      # vip_meds: 'Forms CC VIP Meds',
      cc_vip_sitting: 'Forms CC VIP Sitting',
      vip_strengths: 'Forms CC VIP Strengths',
      vip_challenges: 'Forms CC VIP Challenges',
      vip_mobility: 'Forms CC VIP Mobility',
      # vip_walk: 'Forms CC VIP Walk',
      cc_vip_developmental_age: 'Forms CC VIP child_dev_age',
      cc_vip_staff_administered_meds: 'Forms CC MH MedicationsByStaff',
      # vip_comm: 'Forms CC VIP Comm',
      # vip_comm_addl: 'Forms CC VIP Comm Addl',
      vip_comm_small: 'Forms CC VIP Comm Small',
      vip_comm_large: 'Forms CC VIP Comm Large',
      vip_comm_directions: 'Forms CC VIP Comm Directions',
      vip_stress: 'Forms CC VIP Stress',
      vip_stress_addl: 'Forms CC VIP Stress Addl',
      vip_stress_behavior: 'Forms CC VIP StressBehavior',
      vip_calm: 'Forms CC VIP Calm',
      vip_hobby: 'Forms CC VIP Hobby',
      vip_buddy: 'Forms CC VIP Buddy',
      vip_addl_info: 'Forms CC VIP AddlInfo',
      cc_restriction_certified: 'Forms CC MH Certify',
      
      # sunscreen_self: 'Forms CC Sunscreen Self',
      # sunscreen_assisted: 'Forms CC Sunscreen Assisted',
      # sunscreen_provided: 'Forms CC Sunscreen Provided',
    
      # parent_agree: 'Forms CS ParentAgree',
      # gtky_lunch: 'Forms CS GTKY Lunch',
      cs_chronic_health: 'Forms CS MH Chronic Health',      
      cs_other_special_needs: 'Forms CS MH Special Needs',
      cs_restriction_certified: 'Forms CS MH Certify',
      cs_restrictions: 'Forms CS MH Restrictions',
      cs_vip_developmental_age: 'Forms CS VIP child_dev_age',
      cs_allergies: 'Forms CS MH Allergy Multi',
      cs_medications: 'Forms CS MH Medications',
      cs_vip_staff_administered_meds: 'Forms CS MH MedicationsByStaff',

      gtky_signout: 'Forms CS GTKY Signout',
      gtky_sibling_signout: 'Forms CS GTKY SiblingSignout',
      gtky_sibling: 'Forms CS GTKY Sibling',
      gtky_small_group_friend: 'Forms CS GTKY SmallGroupFriend',
      gtky_leader: 'Forms CS GTKY Leader',
      # gtky_musical: 'Forms CS GTKY Musical',
      gtky_activities: 'Forms CS GTKY Activities',
      gtky_gain: 'Forms CS GTKY Gain',
      gtky_growth: 'Forms CS GTKY Growth',
      gtky_addl_info: 'Forms CS GTKY AddlInfo',
      gtky_challenges: 'Forms CS GTKY Challenges',
      gtky_addl_challenges: 'Forms CS GTKY Addl Challenges',
      gtky_large_groups: 'Forms CS GTKY LargeGroups',
      gtky_small_groups: 'Forms CS GTKY SmallGroups',
      gtky_is_leader: 'Forms CS GTKY IsLeader',
      gtky_is_follower: 'Forms CS GTKY IsFollower',
      gtky_friends: 'Forms CS GTKY Friends',
      gtky_hesitant: 'Forms CS GTKY Hesitant',
      gtky_active: 'Forms CS GTKY Active',
      gtky_reserved: 'Forms CS GTKY Reserved',
      gtky_boundaries: 'Forms CS GTKY Boundaries',
      gtky_authority: 'Forms CS GTKY Authority',
      gtky_adapts: 'Forms CS GTKY Adapts',
      # gtky_allergies: 'Forms CS MH Allergies',
      med_allergies: 'Forms CS MH Med Allergy',      
      # food_allergies: 'Forms CS MH Food Allergies',
      other_allergies: 'Forms CS MH Other Allergy',
      # health_concerns: 'Forms CS MH Health Concerns',
      
      # asthma: 'Forms CS MH Asthma',
      # migraines: 'Forms CS MH Migraines',
      # severe_allergy: 'Forms CS MH Severe allergy',
      # anorexia: 'Forms CS MH Anorexia',
      # diabetes: 'Forms CS MH Diabetes',
      # altitude: 'Forms CS MH Altitude',
      cs_chronic_health_addl: 'Forms CS MH Chronic Health Addl',
      cs_health_misc: 'Forms CS MH Health Misc',
      # cs_vip_meds: 'Forms CS VIP Meds',
      # cs_vip_dev: 'Forms CS VIP Dev',
      cs_vip_strengths: 'Forms CS VIP Strengths',
      cs_vip_challenges: 'Forms CS VIP Challenges',
      cs_vip_mobility: 'Forms CS VIP Mobility',
      # cs_vip_walk: 'Forms CS VIP Walk',
      # cs_vip_comm: 'Forms CS VIP Comm',
      # cs_vip_comm_addl: 'Forms CS VIP Comm Addl',
      cs_vip_comm_small: 'Forms CS VIP Comm Small',
      cs_vip_comm_large: 'Forms CS VIP Comm Large',
      cs_vip_comm_directions: 'Forms CS VIP Comm Directions',
      cs_vip_stress: 'Forms CS VIP Stress',
      cs_vip_stress_addl: 'Forms CS VIP Stress Addl',
      cs_vip_stress_behavior: 'Forms CS VIP StressBehavior',
      cs_vip_calm: 'Forms CS VIP Calm',
      cs_vip_sitting: 'Forms CS VIP Sitting',
      cs_vip_hobby: 'Forms CS VIP Hobby',
      cs_vip_buddy: 'Forms CS VIP Buddy',
      cs_vip_addl_info: 'Forms CS VIP AddlInfo'
    }.freeze      

    attr_accessor(*SPREADSHEET_TITLES.keys)

    SPREADSHEET_REQUIRED_COLUMNS = SPREADSHEET_TITLES.slice(:person_type, :family_tag, :first_name, :last_name).values.freeze

    DATE_ATTRIBUTES = %w[
      birthdate
      arrived_at
      departed_at
      rec_pass_start_at
      rec_pass_end_at
      hired_at
    ].freeze

    PERSON_TYPES = {
      'Primary' => Attendee,
      'Spouse' => Attendee,
      'Child' => Child,
      'Additional Family Member' => Child
    }.freeze

    AGE_GROUPS = {
      'Age 0' => 'age0',
      'Age 1' => 'age1',
      'Age 2' => 'age2',
      'Age 3' => 'age3',
      'Age 4' => 'age4',
      'Age 5 - PreK' => 'age5-pre-kindergarten',
      'Age 5 - K' => 'age5-kindergarten',
      'Grade 1' => 'grade1',
      'Grade 2' => 'grade2',
      'Grade 3' => 'grade3',
      'Grade 4' => 'grade4',
      'Grade 5' => 'grade5',
      'Grade 6' => 'grade6',
      'Grade 7' => 'grade7',
      'Grade 8' => 'grade8',
      'Grade 9' => 'grade9',
      'Grade 10' => 'grade10',
      'Grade 11' => 'grade11',
      'Grade 12' => 'grade12',
      'Grade 13' => 'grade13',
      'Post High School' => 'postHighSchool'
    }.freeze
    raise 'Import age groups do not match Child grade levels!' unless AGE_GROUPS.values == Child::GRADE_LEVELS

    validates :person_type, :first_name, :last_name, :family_tag, presence: true
    validates :gender, inclusion: { in: ::Person::GENDERS.keys.map(&:to_s) }

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

    def gender=(gender)
      @gender = gender&.downcase || 'm'
    end

    def country_code
      ISO3166::Country.find_country_by_alpha3(country)&.alpha2
    end

    def housing_roommates_details
      if housing_roommates_email.present?
        format('%s <%s>', housing_roommates, housing_roommates_email)
      else
        housing_roommates
      end
    end

    def family_record
      Family.includes(:people, :housing_preference).find_by(import_tag: family_tag)
    end

    def housing_single_room=(str)
      @housing_single_room = true_string?(str)
    end

    def housing_accepts_non_ac=(str)
      @housing_accepts_non_ac = true_string?(str)
    end

    def needs_bed=(str)
      @needs_bed = true_string?(str)
    end

    def grade_level=(group)
      @grade_level =
        if (match = AGE_GROUPS[group])
          match
        elsif group.present?
          # go in reverse to match "Grade 10" before "Grade 1"
          AGE_GROUPS.reverse_each.find { |k, _| group.include?(k) }&.last
        end
    end

    def childcare_deposit=(str)
      # weird one: "-1" seems to be true and ""/"0" are false
      @childcare_deposit = str.present? && str != '0'
    end

    def housing_type=(type)
      @housing_type =
        case type&.downcase
        when /dorm/ then :dormitory
        when /apartment/ then :apartment
        when /\Aapt\z/ then :apartment
        else :self_provided
        end
    end

    DATE_ATTRIBUTES.each do |date_attribute_name|
      define_method date_attribute_name do
        parse_american_date instance_variable_get("@#{date_attribute_name}")
      end
    end

    private

    def true_string?(str)
      str&.downcase == 'yes' || TRUE_VALUES.include?(str)
    end

    def parse_american_date(date_string)
      return date_string unless date_string.is_a?(String)

      Date.strptime date_string, '%m/%d/%Y'
    end
  end
end
