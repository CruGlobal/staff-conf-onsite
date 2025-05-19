# rubocop:disable Metrics/ClassLength
class Childcare::SendDocusignEnvelope < ApplicationService
  include PersonHelper

  SendEnvelopeError = Class.new(StandardError)

  KIDS_CARE_WITH_VIP_TEMPLATE = 'c836796a-ad75-4dcb-b132-402b031f70dc'.freeze
  KIDS_CARE_NO_VIP_TEMPLATE   = 'e92627a4-2865-4b81-8de0-6db9f3517576'.freeze
  KIDS_CAMP_WITH_VIP_TEMPLATE = '97ef9609-036b-4d9c-8343-5bec92ea734d'.freeze
  KIDS_CAMP_NO_VIP_TEMPLATE   = '817f4a90-d6f4-4d7a-9500-62e4c0a1f8da'.freeze
  CRUSTU_WITH_VIP_TEMPLATE    = '9e86bc46-fe68-499f-891c-c02bd59ab972'.freeze
  CRUSTU_NO_VIP_TEMPLATE      = '59f3c410-1072-483a-94de-b7c3f06b032d'.freeze
  TEST_RECIPIENT          = 'Cru22KidsForms+DocuSignTesting@cru.org'.freeze
  TRACKING_COPY_RECIPIENT = 'Cru22KidsForms+DocuSignVoid@cru.org'.freeze
  attr_reader :recipient, :child, :note

  def initialize(child, note = nil, recipient: nil)
    @recipient = recipient || child.family.primary_person
    @child = child
    @note = note
  end

  def call
    raise SendEnvelopeError, 'Valid envelope already exists for child' if valid_envelope_exists?

    payload = build_payload(recipient.full_name(skip_middle: true), recipient.email)
    result = Docusign::CreateEnvelopeFromTemplate.new(payload).call

    if result && result['envelopeId']
      child.childcare_envelopes.create(envelope_id: result['envelopeId'], status: result['status'], recipient: recipient)
    end
  end

  private

  def valid_envelope_exists?
    child.completed_envelope? || child.pending_envelope?
  end

  def build_payload(recipient_name, recipient_email)
    recipient_email = TEST_RECIPIENT unless Rails.env.production?
    {
      status: 'sent',
      email: build_docusign_email_block,
      template_id: determine_docusign_template,
      signers: [
        {
          embedded: false,
          name: recipient_name,
          email: recipient_email,
          role_name: 'Parent',
          text_tabs: build_text_tabs
        },
        {
          embedded: false,
          name: child_name_grade_and_arrival_date,
          email: TRACKING_COPY_RECIPIENT,
          role_name: 'Child',
          text_tabs: build_text_tabs
        }
      ]
    }
  end

  def build_docusign_email_block
    {
      subject: "#{UserVariable[:conference_id]} Authorization and Consent Packet for #{child_name_grade_and_arrival_date}",
      body: note
    }
  end

  def child_name_grade_and_arrival_date
    [
      without_commas(child.last_name),
      without_commas(child.first_name),
      grade_level_label(child, shorten: true)
      #,child.arrived_at&.strftime('%m/%d/%Y')
    ].join(', ')
  end

  def without_commas(string)
    string.delete(',')
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def determine_docusign_template
    if Child.kids_care_grades.include?(child.grade_level)
      childcare_no_misc_health? ? KIDS_CARE_NO_VIP_TEMPLATE : KIDS_CARE_WITH_VIP_TEMPLATE
    elsif Child.kids_camp_grades.include?(child.grade_level)
      childcare_no_misc_health? ? KIDS_CAMP_NO_VIP_TEMPLATE : KIDS_CAMP_WITH_VIP_TEMPLATE
    elsif Child.senior_grade_levels.include?(child.grade_level)
      senior_no_misc_health? ? CRUSTU_NO_VIP_TEMPLATE : CRUSTU_WITH_VIP_TEMPLATE
    else
      raise SendEnvelopeError, 'There is an error on the child record, possibly incomplete details'
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity

  def childcare_no_misc_health?
    misc = child&.childcare_medical_history&.health_misc
    misc.blank? || misc == ['None of the above']
  end

  def senior_no_misc_health?
    misc = child&.cru_student_medical_history&.cs_health_misc
    misc.blank? || misc == ['None of the above']
  end

  def build_text_tabs
    @build_text_tabs ||= build_general_fields + build_cc_medical_history_fields + build_cc_vip_fields +
                         build_cs_gtky_fields + build_cs_medical_history_fields + build_cs_vip_fields
  end

  # For each attribute, create { label: attr_name, value: attr_value }
  # If label is present multiple times on form, preprend \\* to label
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_general_fields
    [
      {
        label: 'SCOPersonID',
        value: child.uuid
      },
      {
        label: '\\*ChildFullName',
        value: child.full_name(skip_middle: true)
      },
      {
        label: '\\*Birthdate',
        value: child.birthdate&.strftime('%m/%d/%Y').to_s
      },
      {
        label: '\\*Age',
        value: calculate_age(child.birthdate).to_s
      },
      {
        label: '\\*AgeGroup',
        value: grade_level_label(child).to_s
      },
      {
        label: 'ChildPreferredFullName',
        value: "#{child.name_tag_first_name} #{child.name_tag_last_name}"
      },      
      {
        label: '\\*Parent1FullName',
        value: recipient.full_name(skip_middle: true)
      },
      {
        label: '\\*Parent1Mobile',
        value: recipient.phone
      },
      {
        label: '\\*Parent2FullName',
        value: recipient&.spouse&.full_name(skip_middle: true)
      },
      {
        label: '\\*Parent2Mobile',
        value: recipient&.spouse&.phone
      },
      {
        label: '\\*Parent2Email',
        value: recipient&.spouse&.email
      },
      {
        label: '\\*Parent1Ministry',
        value: recipient.main_ministry&.name
      },
      {
        label: '\\*Parent1Cohort',
        value: get_cohort_for(recipient)
      },
      {
        label: '\\*HomeStreet',
        value: child.family.address1
      },
      {
        label: '\\*HomeCity',
        value: child.family.city
      },
      {
        label: '\\*HomeCounty',
        value: get_county(child)
      },
      {
        label: '\\*HomeState',
        value: child.family&.state
      },
      {
        label: '\\*HomeAddress',
        value: get_full_address(child.family)
      },
      {
        label: '\\*Gender',
        value: get_gender_formatted(child.gender)
      },
      {
        label: '\\*ChildGender',
        value:  get_gender_formatted(child.gender)
      },
      {
        label: '\\*Parent1Email',
        value: recipient.email
      }
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_cc_medical_history_fields
    return [] unless child.childcare_medical_history

    mh = child.childcare_medical_history
    [
      {
        label: 'Forms-CC-MH-Allergies-Eggs',
        value: check_if_in_list(mh.cc_allergies, 'Eggs')
      },
      {
        label: 'Forms-CC-MH-Allergies-Milk',
        value: check_if_in_list(mh.cc_allergies, 'Milk')
      },
      {
        label: 'Forms-CC-MH-Allergies-TreeNuts',
        value: check_if_in_list(mh.cc_allergies, 'Tree nuts')
      },
      {
        label: 'Forms-CC-MH-Allergies-Fish',
        value: check_if_in_list(mh.cc_allergies, 'Fish/Shellfish')
      },
      {
        label: 'Forms-CC-MH-Allergies-Peanuts',
        value: check_if_in_list(mh.cc_allergies, 'Peanuts')
      },
      {
        label: 'Forms-CC-MH-Allergies-Wheat',
        value: check_if_in_list(mh.cc_allergies, 'Wheat')
      },
      {
        label: 'Forms-CC-MH-Allergies-InsectSting',
        value: check_if_in_list(mh.cc_allergies, 'Insect sting')
      },
      {
        label: 'Forms-CC-MH-Allergies-Pollen',
        value: check_if_in_list(mh.cc_allergies, 'Pollen')
      },
      {
        label: 'Forms-CC-MH-Allergies-Meds',
        value: check_if_in_list(mh.cc_allergies, 'Medications')
      },
      {
        label: 'Forms-CC-MH-Allergies-Latex',
        value: check_if_in_list(mh.cc_allergies, 'Latex')
      },
      {
        label: 'Forms-CC-MH-Allergies-Soy',
        value: check_if_in_list(mh.cc_allergies, 'Soy')
      },
      {
        label: 'Forms-CC-MH-Allergies-Other',
        value: check_if_in_list(mh.cc_allergies, 'Other')
      },
      {
        label: 'Forms-CC-MH-Allergies-Nota',
        value: check_if_in_list(mh.cc_allergies, 'None of the above')
      },
      {
        label: 'Forms-CC-MH-Med-Allergies',
        value: mh.cc_medi_allergy
      },
      {
        label: 'Forms-CC-MH-Other-Allergies',
        value: mh.allergy
      },
      {
        label: 'Forms-CC-MH-Food-Intolerance',
        value: mh.food_intolerance
      },
      {
        label: 'Forms-CC-MH-Chronic-Asthma',
        value: check_if_in_list(mh.chronic_health, 'Asthma')
      },
      {
        label: 'Forms-CC-MH-Chronic-Diabetes',
        value: check_if_in_list(mh.chronic_health, 'Diabetes')
      },
      {
        label: 'Forms-CC-MH-Chronic-Epilepsy',
        value: check_if_in_list(mh.chronic_health, 'Epilepsy')
      },
      {
        label: 'Forms-CC-MH-Chronic-SevereAllergy',
        value: check_if_in_list(mh.chronic_health, 'Severe allergy')
      },
      {
        label: 'Forms-CC-MH-Chronic-Other',
        value: check_if_in_list(mh.chronic_health, 'Other')
      },
      {
        label: 'Forms-CC-MH-Chronic-Nota',
        value: check_if_in_list(mh.chronic_health, 'None of the above')
      },
      {
        label: 'Forms-CC-MH-Chronic-OtherAdditional',
        value: mh.chronic_health_addl
      },
      {
        label: '\\*Forms-CC-MH-AllMeds',
        value: mh.medications
      },      
      {
        label: 'Forms CC MH Immunizations',
        value: checkmark_if_yes(mh.immunizations&.join)
      },
      {
        label: 'Forms CC MH non-immunized',
        value: checkmark_if_yes(mh.non_immunizations&.join)
      },
      {
        label: 'Forms-CC-MH-Certify-No',        
        value: checkmark_if_value(mh.cc_restriction_certified, 'CruKids_certify_NOres')
      },
      {
        label: 'Forms-CC-MH-Certify-Yes',
        value: checkmark_if_value(mh.cc_restriction_certified, 'CruKids_certify_WITHres')
      },
      {
        label: 'Forms-CC-MH-Certify-Restrictions',
        value: mh.restrictions
      },
      {
        label: 'Forms-CC-MH-Health-Misc-DownSyndrome',
        value: check_if_in_list(mh.health_misc, 'Down Syndrome')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-ADHD',
        value: check_if_in_list(mh.health_misc, 'ADHD')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Developmental-delay',
        value: check_if_in_list(mh.health_misc, 'Developmental delay')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Other-special-need',
        value: check_if_in_list(mh.health_misc, 'Other')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Behavioral-challenges',
        value: check_if_in_list(mh.health_misc, 'Behavioral challenges')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Autism',
        value: check_if_in_list(mh.health_misc, 'Autism')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Extra-assistance',
        value: check_if_in_list(mh.health_misc, 'Extra assistance')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Adaptive-equipment',
        value: check_if_in_list(mh.health_misc, 'Adaptive equipment')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Nota',
        value: check_if_in_list(mh.health_misc, 'None of the above')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-Other',
        value: check_if_in_list(mh.health_misc, 'Other')
      },
      {
        label: 'Forms-CC-MH-Health-Misc-OtherSpecialNeeds',
        value: mh.cc_other_special_needs
      }
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_cc_vip_fields
    return [] unless child.childcare_medical_history

    mh = child.childcare_medical_history
    [
      {
        label: 'Forms-CC-VIP-Meds',
        value: mh.vip_meds
      },
      {
        label: '\\*Forms-CC-VIP-DevAge',
        value: mh.cc_vip_developmental_age
      },
      {
        label: 'Forms-CC-VIP-Strengths',
        value: mh.vip_strengths
      },
      {
        label: 'Forms-CC-VIP-Challenges',
        value: mh.vip_challenges
      },
      {
        label: 'Forms-CC-VIP-Mobility',
        value: mh.vip_mobility
      },
      {
        label: 'Forms-CC-VIP-Walk',
        value: mh.vip_walk
      },
      {
        label: 'Forms-CC-VIP-Comm-Simple',
        value: check_if_in_list(mh.vip_comm, 'In simple phrases')
      },
      {
        label: 'Forms-CC-VIP-Comm-Sentences',
        value: check_if_in_list(mh.vip_comm, 'In complete sentences')
      },
      # {
      #   label: 'Forms-CC-VIP-Comm-Visual',
      #   value: check_if_in_list(mh.vip_comm, 'Visual schedule')
      # },
      {
        label: 'Forms-CC-VIP-Comm-Other',
        value: check_if_in_list(mh.vip_comm, 'Other')
      },
      {
        label: 'Forms-CC-VIP-Comm-Addl',
        value: mh.vip_comm_addl
      },
      {
        label: 'Forms-CC-VIP-Comm-Small',
        value: mh.vip_comm_small
      },
      {
        label: 'Forms-CC-VIP-Comm-Large',
        value: mh.vip_comm_large
      },
      {
        label: 'Forms-CC-VIP-Comm-Directions',
        value: mh.vip_comm_directions
      },
      {
        label: 'Forms-CC-VIP-Stress-Noisy-spaces',
        value: check_if_in_list(mh.vip_stress, 'Noisy spaces')
      },
      {
        label: 'Forms-CC-VIP-Stress-Crowded-spaces',
        value: check_if_in_list(mh.vip_stress, 'Crowded spaces')
      },
      {
        label: 'Forms-CC-VIP-Stress-Loud-noises',
        value: check_if_in_list(mh.vip_stress, 'Loud noises')
      },
      {
        label: 'Forms-CC-VIP-Stress-Heights',
        value: check_if_in_list(mh.vip_stress, 'Heights')
      },
      {
        label: 'Forms-CC-VIP-Stress-ChangingSchedule',
        value: check_if_in_list(mh.vip_stress, 'Changing schedule')
      },
      {
        label: 'Forms-CC-VIP-Stress-Other',
        value: check_if_in_list(mh.vip_stress, 'Other')
      },
      {
        label: 'Forms-CC-VIP-Stress-Nota',
        value: check_if_in_list(mh.vip_stress, 'None of the above')
      },
      {
        label: 'Forms-CC-VIP-Sitting',
        value: mh.cc_vip_sitting
      },
      {
        label: 'Forms-CC-VIP-Stress-Addl',
        value: mh.vip_stress_addl
      },
      {
        label: 'Forms-CC-VIP-StressBehavior',
        value: mh.vip_stress_behavior
      },
      {
        label: 'Forms-CC-VIP-Calm',
        value: mh.vip_calm
      },
      {
        label: 'Forms-CC-VIP-Hobby',
        value: mh.vip_hobby
      },
      {
        label: 'Forms-CC-VIP-Buddy',
        value: mh.vip_buddy
      },
      {
        label: 'Forms-CC-VIP-AddlInfo',
        value: mh.vip_addl_info
      },
      {
        label: '\\*Forms-CC-MH-StaffAdministeredMeds',
        value: mh.cc_vip_staff_administered_meds
      }
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_cs_gtky_fields
    return [] unless child.cru_student_medical_history

    smh = child.cru_student_medical_history
    [
      # {
      #   label: 'Forms-CS-GTKY-Lunch-Yes',
      #   value: checkmark_if_yes_present(smh.gtky_lunch)
      # },
      # {
      #   label: 'Forms-CS-GTKY-Lunch-No',
      #   value: checkmark_if_no_present(smh.gtky_lunch)
      # },
      {
        label: 'Forms-CS-GTKY-Signout-Yes',
        value: checkmark_if_yes_present(smh.gtky_signout)
      },
      {
        label: 'Forms-CS-GTKY-Signout-No',
        value: checkmark_if_no_present(smh.gtky_signout)
      },
      {
        label: 'Forms-CS-GTKY-SiblingSignout',
        value: smh.gtky_sibling_signout
      },
      {
        label: 'Forms-CS-GTKY-Sibling-Yes',
        value: checkmark_if_yes(smh.gtky_sibling)
      },
      {
        label: 'Forms-CS-GTKY-Sibling-No',
        value: checkmark_if_no(smh.gtky_sibling)
      },
      {
        label: 'Forms-CS-GTKY-SmallGroupFriend',
        value: smh.gtky_small_group_friend
      },
      {
        label: 'Forms-CS-GTKY-Leader-Yes',
        value: checkmark_if_yes(smh.gtky_leader)
      },
      {
        label: 'Forms-CS-GTKY-Leader-No',
        value: checkmark_if_no(smh.gtky_leader)
      },
      # {
      #   label: 'Forms-CS-GTKY-Musical-Yes',
      #   value: checkmark_if_yes(smh.gtky_musical)
      # },
      # {
      #   label: 'Forms-CS-GTKY-Musical-No',
      #   value: checkmark_if_no(smh.gtky_musical)
      # },
      {
        label: 'Forms-CS-GTKY-Activities',
        value: smh.gtky_activities
      },
      {
        label: 'Forms-CS-GTKY-Gain',
        value: smh.gtky_gain
      },
      {
        label: 'Forms-CS-GTKY-Growth',
        value: smh.gtky_growth
      },
      {
        label: 'Forms-CS-GTKY-AddlInfo',
        value: smh.gtky_addl_info
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Death',
        value: check_if_in_list(smh.gtky_challenges, 'Death')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Divorce',
        value: check_if_in_list(smh.gtky_challenges, 'Divorce')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Abuse',
        value: check_if_in_list(smh.gtky_challenges, 'Abuse')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Anger-issues',
        value: check_if_in_list(smh.gtky_challenges, 'Anger issues')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Anxiety',
        value: check_if_in_list(smh.gtky_challenges, 'Anxiety')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Eating-disorder',
        value: check_if_in_list(smh.gtky_challenges, 'Eating disorder')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Major-life-change',
        value: check_if_in_list(smh.gtky_challenges, 'Major life change')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Depression',
        value: check_if_in_list(smh.gtky_challenges, 'Depression')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Significant-bullying',
        value: check_if_in_list(smh.gtky_challenges, 'Significant bullying')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Behavioral-issues',
        value: check_if_in_list(smh.gtky_challenges, 'Behavioral issues')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Self-harm',
        value: check_if_in_list(smh.gtky_challenges, 'Self harm')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Bipolar-disorder',
        value: check_if_in_list(smh.gtky_challenges, 'Bipolar disorder')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Foster-Adoption',
        value: check_if_in_list(smh.gtky_challenges, 'Foster Adoption')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Other',
        value: check_if_in_list(smh.gtky_challenges, 'Other')
      },
      {
        label: 'Forms-CS-GTKY-Challenges-Nota',
        value: check_if_in_list(smh.gtky_challenges, 'None of the above')
      },
      {
        label: 'Forms-CS-GTKY-Addl-Challenges',
        value: smh.gtky_addl_challenges
      },
      {
        label: 'Forms-CS-GTKY-LargeGroups',
        value: smh.gtky_large_groups
      },
      {
        label: 'Forms-CS-GTKY-SmallGroups',
        value: smh.gtky_small_groups
      },
      {
        label: 'Forms-CS-GTKY-IsLeader',
        value: smh.gtky_is_leader
      },
      {
        label: 'Forms-CS-GTKY-IsFollower',
        value: smh.gtky_is_follower
      },
      {
        label: 'Forms-CS-GTKY-Friends',
        value: smh.gtky_friends
      },
      {
        label: 'Forms-CS-GTKY-Hesitant',
        value: smh.gtky_hesitant
      },
      {
        label: 'Forms-CS-GTKY-Active',
        value: smh.gtky_active
      },
      {
        label: 'Forms-CS-GTKY-Reserved',
        value: smh.gtky_reserved
      },
      {
        label: 'Forms-CS-GTKY-Boundaries',
        value: smh.gtky_boundaries
      },
      {
        label: 'Forms-CS-GTKY-Authority',
        value: smh.gtky_authority
      },
      {
        label: 'Forms-CS-GTKY-Adapts',
        value: smh.gtky_adapts
      }
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_cs_medical_history_fields
    return [] unless child.cru_student_medical_history

    smh = child.cru_student_medical_history
    [
      {
        label: 'Forms-CS-MH-Allergies-Eggs',
        value: check_if_in_list(smh.cs_allergies, 'Eggs')
      },
      {
        label: 'Forms-CS-MH-Allergies-Milk',
        value: check_if_in_list(smh.cs_allergies, 'Milk')
      },
      {
        label: 'Forms-CS-MH-Allergies-TreeNuts',
        value: check_if_in_list(smh.cs_allergies, 'Tree nuts')
      },
      {
        label: 'Forms-CS-MH-Allergies-Fish',
        value: check_if_in_list(smh.cs_allergies, 'Fish/Shellfish')
      },
      {
        label: 'Forms-CS-MH-Allergies-Peanuts',
        value: check_if_in_list(smh.cs_allergies, 'Peanuts')
      },
      {
        label: 'Forms-CS-MH-Allergies-Wheat',
        value: check_if_in_list(smh.cs_allergies, 'Wheat')
      },
      {
        label: 'Forms-CS-MH-Allergies-InsectSting',
        value: check_if_in_list(smh.cs_allergies, 'Insect sting')
      },
      {
        label: 'Forms-CS-MH-Allergies-Pollen',
        value: check_if_in_list(smh.cs_allergies, 'Pollen')
      },
      {
        label: 'Forms-CS-MH-Allergies-Meds',
        value: check_if_in_list(smh.cs_allergies, 'Medications')
      },
      {
        label: 'Forms-CS-MH-Allergies-Latex',
        value: check_if_in_list(smh.cs_allergies, 'Latex')
      },
      {
        label: 'Forms-CS-MH-Allergies-Soy',
        value: check_if_in_list(smh.cs_allergies, 'Soy')
      },
      {
        label: 'Forms-CS-MH-Allergies-Other',
        value: check_if_in_list(smh.cs_allergies, 'Other')
      },
      {
        label: 'Forms-CS-MH-Allergies-Nota',
        value: check_if_in_list(smh.cs_allergies, 'None of the above')
      },
      {
        label: 'Forms-CS-MH-Med-Allergies',
        value: smh.med_allergies
      },
      {
        label: 'Forms-CS-MH-Food-Allergies',
        value: smh.food_allergies
      },
      {
        label: 'Forms-CS-MH-Other-Allergies',
        value: smh.other_allergies
      },
      {
        label: 'Forms-CS-MH-Health-Concerns-No',
        value: checkmark_if_no(smh.health_concerns)
      },
      {
        label: 'Forms-CS-MH-Health-Concerns-Yes',
        value: checkmark_if_yes(smh.health_concerns)
      },
      {
        label: 'Forms-CS-MH-Chronic-Asthma',
        value: check_if_in_list(smh.cs_chronic_health, 'Asthma')
      },
      {
        label: 'Forms-CS-MH-Chronic-Migraine',
        value: check_if_in_list(smh.cs_chronic_health, 'Migraines')
      },
      {
        label: 'Forms-CS-MH-Chronic-SevereAllergy',
        value: check_if_in_list(smh.cs_chronic_health, 'Severe allergy')
      },
      {
        label: 'Forms-CS-MH-Chronic-Anorexia',
        value: check_if_in_list(smh.cs_chronic_health, 'Anorexia')
      },
      {
        label: 'Forms-CS-MH-Chronic-Diabetes',
        value: check_if_in_list(smh.cs_chronic_health, 'Diabetes')
      },
      {
        label: 'Forms-CS-MH-Chronic-Epilepsy',
        value: check_if_in_list(smh.cs_chronic_health, 'Epilepsy')  
      },
      {
        label: 'Forms-CS-MH-Chronic-Other',
        value: check_if_in_list(smh.cs_chronic_health, 'Other')
      },
      {
        label: 'Forms-CS-MH-Chronic-Nota',
        value: check_if_in_list(smh.cs_chronic_health, 'None of the above')  
      },
      {
        label: 'Forms-CS-MH-Altitude',
        value: smh.altitude
      },
      {
        label: 'Forms-CS-MH-Chronic-OtherAdditional',
        value: smh.cs_chronic_health_addl
      },
      {
        label: '\\*Forms-CS-MH-AllMeds',
        value: smh.cs_medications
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Developmental-delay',
        value: check_if_in_list(smh.cs_health_misc, 'Developmental delay')
      },
      # {
      #   label: 'Forms-CS-MH-Health-Misc-Sensory-issues',
      #   value: check_if_in_list(smh.cs_health_misc, 'Sensory issues')
      # },
      {
        label: 'Forms-CS-MH-Health-Misc-Other',
        value: check_if_in_list(smh.cs_health_misc, 'Other')### added JaPache
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Behavioral-challenges',
        value: check_if_in_list(smh.cs_health_misc, 'Behavioral challenges')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Disability',
        value: check_if_in_list(smh.cs_health_misc, 'Disability')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Extra-assistance',
        value: check_if_in_list(smh.cs_health_misc, 'Extra assistance')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Adaptive-equipment',
        value: check_if_in_list(smh.cs_health_misc, 'Adaptive equipment')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-ADHD',
        value: check_if_in_list(smh.cs_health_misc, 'ADHD')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-DownSyndrome',
        value: check_if_in_list(smh.cs_health_misc, 'Down Syndrome')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Autism',
        value: check_if_in_list(smh.cs_health_misc, 'Autism')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-Nota',
        value: check_if_in_list(smh.cs_health_misc, 'None of the above')
      },
      {
        label: 'Forms-CS-MH-Health-Misc-OtherSpecialNeeds',
        value: smh.cs_other_special_needs
      },
      {
        label: 'Forms-CS-MH-Certify-No',
        value: checkmark_if_value(smh.cs_restriction_certified, 'CruKids_certify_NOres')
      },
      {
        label: 'Forms-CS-MH-Certify-Yes',
        value: checkmark_if_value(smh.cs_restriction_certified, 'CruKids_certify_WITHres')
      },
      {
        label: 'Forms-CS-MH-Certify-Restrictions',
        value: smh.cs_restrictions
      }
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_cs_vip_fields
    return [] unless child.cru_student_medical_history

    smh = child.cru_student_medical_history
    [
      {
        label: 'Forms-CS-VIP-Meds',
        value: smh.cs_vip_meds
      },
      {
        label: 'Forms-CS-VIP-DevAge',
        value: smh.cs_vip_developmental_age
      },
      {
        label: 'Forms-CS-VIP-Strengths',
        value: smh.cs_vip_strengths
      },
      {
        label: 'Forms-CS-VIP-Challenges',
        value: smh.cs_vip_challenges
      },
      {
        label: 'Forms-CS-VIP-Mobility',
        value: smh.cs_vip_mobility
      },
      {
        label: 'Forms-CS-VIP-Walk',
        value: smh.cs_vip_walk
      },
      {
        label: 'Forms-CS-VIP-Comm-In-simple-phrases',
        value: check_if_in_list(smh.cs_vip_comm, 'In simple phrases')
      },
      {
        label: 'Forms-CS-VIP-Comm-In-complete-sentences',
        value: check_if_in_list(smh.cs_vip_comm, 'In complete sentences')
      },
      {
        label: 'Forms-CS-VIP-Comm-Other',
        value: check_if_in_list(smh.cs_vip_comm, 'Other')
      },
      {
        label: 'Forms-CS-VIP-Comm-Addl',
        value: smh.cs_vip_comm_addl
      },
      {
        label: 'Forms-CS-VIP-Comm-Small',
        value: smh.cs_vip_comm_small
      },
      {
        label: 'Forms-CS-VIP-Comm-Large',
        value: smh.cs_vip_comm_large
      },
      {
        label: 'Forms-CS-VIP-Comm-Directions',
        value: smh.cs_vip_comm_directions
      },
      {
        label: 'Forms-CS-VIP-Stress-Noisy-spaces',
        value: check_if_in_list(smh.cs_vip_stress, 'Noisy spaces')
      },
      {
        label: 'Forms-CS-VIP-Stress-Crowded-spaces',
        value: check_if_in_list(smh.cs_vip_stress, 'Crowded spaces')
      },
      {
        label: 'Forms-CS-VIP-Stress-Loud-noises',
        value: check_if_in_list(smh.cs_vip_stress, 'Loud noises')
      },
      {
        label: 'Forms-CS-VIP-Stress-Heights',
        value: check_if_in_list(smh.cs_vip_stress, 'Heights')
      },
      {
        label: 'Forms-CS-VIP-Stress-ChangingSchedule',
        value: check_if_in_list(smh.cs_vip_stress, 'Changing schedule')
      },
      {
        label: 'Forms-CS-VIP-Stress-Other',
        value: check_if_in_list(smh.cs_vip_stress, 'Other')
      },
      {
        label: 'Forms-CS-VIP-Stress-Nota',
        value: check_if_in_list(smh.cs_vip_stress, 'None of the above')
      },
      {
        label: 'Forms-CS-VIP-Sitting',
        value: smh.cs_vip_sitting
      },
      {
        label: 'Forms-CS-VIP-Stress-Addl',
        value: smh.cs_vip_stress_addl
      },
      {
        label: 'Forms-CS-VIP-StressBehavior',
        value: smh.cs_vip_stress_behavior
      },
      {
        label: 'Forms-CS-VIP-Calm',
        value: smh.cs_vip_calm
      },
      {
        label: 'Forms-CS-VIP-Sitting',
        value: smh.cs_vip_sitting
      },
      {
        label: 'Forms-CS-VIP-Hobby',
        value: smh.cs_vip_hobby
      },
      {
        label: 'Forms-CS-VIP-Buddy',
        value: smh.cs_vip_buddy
      },
      {
        label: 'Forms-CS-VIP-AddlInfo',
        value: smh.cs_vip_addl_info
      },
      {
        label: '\\*Forms-CS-MH-StaffAdministeredMeds',
        value: smh.cs_vip_staff_administered_meds
      }
      
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def calculate_age(birthdate)
    return if birthdate.blank?

    age = Time.zone.today.year - birthdate.year
    age -= 1 if Time.zone.today < birthdate + age.years
    age
  end

  def get_gender_formatted(gender)
    case gender.upcase
    when 'M'
      "Male"
    when 'F'
      "Female"
    else
      gender
    end
  end

  def get_full_address(family)
    address = ''
    address += family.address2 if family.address2
    address += family.address1
    address += ", #{family.city}"
    address += ", #{family.state}" if family.state
    address += ", #{family.zip}" if family.zip
    address += " #{ISO3166::Country[family.country_code]}"
    address
  end

  def get_cohort_for(recipient)
    recipient.cohort&.name if recipient.campus_ministry_member?
  end

  def check_if_in_list(existing_conditions, condition)
    return '' if existing_conditions.blank?

    existing_conditions.include?(condition) ? 'X' : ''
  end

  def checkmark_if_yes(attribute)
    return '' if attribute.blank?

    attribute.casecmp('yes').zero? ? 'X' : ''
  end

  def checkmark_if_no(attribute)
    return '' if attribute.blank?

    attribute.casecmp('no').zero? ? 'X' : ''
  end

  def checkmark_if_yes_present(attribute)
    return '' if attribute.blank?

    attribute.include?('YES') ? 'X' : ''
  end

  def checkmark_if_no_present(attribute)
    return '' if attribute.blank?

    attribute.include?('NO') ? 'X' : ''
  end

  def checkmark_if_value(attribute, expected_value)
    return '' if attribute.blank?

    attribute.to_s.casecmp(expected_value.to_s).zero? ? 'X' : ''
  end

  def get_county(child)
    child.county.presence || child.family&.county
  end 
end
# rubocop:enable Metrics/ClassLength
