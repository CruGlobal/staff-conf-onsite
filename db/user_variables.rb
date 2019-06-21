class SeedUserVariables
  RECORDS = {
    rec_center_daily: { value_type: :money, code: :RP, value: 1_00,
      description: 'Rec Center Pass Per Day' },
    child_age_cutoff: { value_type: :date, code: :CCD, value: '2017-07-01',
      description: 'Child Age Cut-off Date' },

    # Facility Use
    facility_use_start: { value_type: :date, code: :FUFSTART, value: '2017-07-01',
      description: 'The first possible chargeable date for Facility Use Fee. If the attendee arrives before this date, the fee isn\'t charged until this date' },
    facility_use_end: { value_type: :date, code: :FUFEND, value: '2017-12-31',
      description: 'The last possible chargeable date for Facility Use Fee. If the attendee leaves after this date, the fee is charged only up to this date.' },
    facility_use_split: { value_type: :date, code: :FUFSPLIT, value: '2017-12-31',
      description: 'Facility usage fee - split date' },
    facility_use_before: { value_type: :money, code: :FUFP1, value: 1_00,
      description: 'Daily FUF rate before the split' },
    facility_use_after: { value_type: :money, code: :FUFP2, value: 2_00,
      description: 'Daily FUF rate after the split' },

    # Childcare Weekly Costs
    childcare_week_0: { value_type: :money, code: :CCWK1,  value: 1_00, description: 'Week 1 Kids Care' },
    childcare_week_1: { value_type: :money, code: :CCWK2,  value: 1_00, description: 'Week 2 Kids Care' },
    childcare_week_2: { value_type: :money, code: :CCWK3,  value: 1_00, description: 'Week 3 Kids Care' },
    childcare_week_3: { value_type: :money, code: :CCWK4,  value: 1_00, description: 'Week 4 Kids Care' },
    childcare_week_4: { value_type: :money, code: :CCWKSC, value: 1_00, description: 'Staff Conference Kids Care' },

    childcare_deposit: { value_type: :money, code: :CCNRF, value: 1_00,
      description: 'This is the non-refundable registration fee for any child' \
                   ' registered for either childcare or JrSr High programs.' },

    # Jr/Sr Weekly Costs
    junior_senior_week_0: { value_type: :money, code: :JRSRWK1,  value: 1_00, description: 'Week 1 Junior Senior' },
    junior_senior_week_1: { value_type: :money, code: :JRSRWK2,  value: 1_00, description: 'Week 2 Junior Senior' },
    junior_senior_week_2: { value_type: :money, code: :JRSRWK3,  value: 1_00, description: 'Week 3 Junior Senior' },
    junior_senior_week_3: { value_type: :money, code: :JRSRWK4,  value: 1_00, description: 'Week 4 Junior Senior' },
    junior_senior_week_4: { value_type: :money, code: :JRSRWKSC, value: 1_00, description: 'Staff Conference Junior Senior' },

    # Hot Lunches
    hot_lunch_week_0: { value_type: :money, code: :HL1,  value: 1_00, description: 'Cost of the Week 1 Hot Lunches' },
    hot_lunch_week_1: { value_type: :money, code: :HL2,  value: 2_00, description: 'Cost of the Week 2 Hot Lunches' },
    hot_lunch_week_2: { value_type: :money, code: :HL3,  value: 4_00, description: 'Cost of the Week 3 Hot Lunches' },
    hot_lunch_week_3: { value_type: :money, code: :HL4,  value: 8_00, description: 'Cost of the Week 4 Hot Lunches' },
    hot_lunch_week_4: { value_type: :money, code: :HLSC, value: 16_00, description: 'Cost of the Staff Conference Hot Lunches' },

    # Hot Lunch Start Dates
    hot_lunch_begin_0: { value_type: :date, code: :HLFDW1, value: '2017-07-01', description: 'Hot Lunch First Day of Week 1' },
    hot_lunch_begin_1: { value_type: :date, code: :HLFDW2, value: '2017-07-08', description: 'Hot Lunch First Day of Week 2' },
    hot_lunch_begin_2: { value_type: :date, code: :HLFDW3, value: '2017-07-15', description: 'Hot Lunch First Day of Week 3' },
    hot_lunch_begin_3: { value_type: :date, code: :HLFDW4, value: '2017-07-22', description: 'Hot Lunch First Day of Week 4' },
    hot_lunch_begin_4: { value_type: :date, code: :HLFDSC, value: '2017-07-29', description: 'Hot Lunch First Day of Staff Conference' },

    # Conference
    conference_id:       { value_type: :string, code: :CONFID, value: 'Cru17', description: 'A string containing the name of the conference.' },
    support_email:       { value_type: :string, code: :SUPPORTEMAIL, value: 'help@cru.org', description: 'Support email address' },
    conference_logo_url: { value_type: :string, code: :CONFLOGO, value: 'https://www.cru.org/content/dam/cru/cru19/cru19-logo-thumbnail.png', description: 'Conference logo URL' },

    # Mail
    mail_interceptor_email_addresses: { value_type: :list, code: :MAIL_INTERCEPTOR_EMAILS, value: 'interceptor_one@example.com, interceptor_two@example.com',
      description: 'A list of email addresses. When this list of email addresses is not empty then all emails will be sent to this list INSTEAD of the original recipient. '\
                   'This prevents emails from going to real users and is intended to be used for testing purposes.' },

    mail_bcc_email_addresses: { value_type: :list, code: :MAIL_BCC_EMAILS, value: 'blind_copy_one@example.com, blind_copy_two@example.com',
      description: 'A list of email addresses. These email addresses will be appended to the BCC recipients. This can be used to monitor the emails that are being sent out to users.' },
  }.freeze

  def initialize
    @existing = UserVariable.keys
  end

  def call
    RECORDS.each { |name, attributes| create_unless_exists(name, attributes) }
  end

  private

  def create_unless_exists(short_name, attributes = {})
    UserVariable.create!(attributes.merge(short_name: short_name))
  rescue ActiveRecord::RecordInvalid
  end
end
