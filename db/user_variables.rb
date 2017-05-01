class SeedUserVariables
  RECORDS = {
    rec_center_daily: { value_type: :money, code: :RP, value: 1_00,
      description: 'Rec Center Pass Per Day' },
    child_age_cutoff: { value_type: :date, code: :CCD, value: '2017-07-01',
      description: 'Child Age Cut-off Date' },
    childcare_first_day: { value_type: :date, code: :CFD, value: '2017-07-01',
      description: 'The first day of the first week of ChildCare' },

    # Childcare Weeks
    childcare_week_0: { value_type: :money, code: :CCWK1, value: 1_00,
      description: 'Week 1 Childcare' },
    childcare_week_1: { value_type: :money, code: :CCWK2, value: 1_00,
      description: 'Week 2 Childcare' },
    childcare_week_2: { value_type: :money, code: :CCWK3, value: 1_00,
      description: 'Week 3 Childcare' },
    childcare_week_3: { value_type: :money, code: :CCWK4, value: 1_00,
      description: 'Week 4 Childcare' },
    childcare_week_4: { value_type: :money, code: :CCWKSC, value: 1_00,
      description: 'Staff Conference Childcare' },
    childcare_deposit: { value_type: :money, code: :CCNRF, value: 1_00,
      description: 'This is the non-refundable registration fee for any child' \
                   ' registered for either childcare or JrSr High programs.' },

    # Jr/Sr Weeks
    junior_senior_week_0: { value_type: :money, code: :JRSRWK1, value: 1_00,
      description: 'Week 1 Junior Senior' },
    junior_senior_week_1: { value_type: :money, code: :JRSRWK2, value: 1_00,
      description: 'Week 2 Junior Senior' },
    junior_senior_week_2: { value_type: :money, code: :JRSRWK3, value: 1_00,
      description: 'Week 3 Junior Senior' },
    junior_senior_week_3: { value_type: :money, code: :JRSRWK4, value: 1_00,
      description: 'Week 4 Junior Senior' },
    junior_senior_week_4: { value_type: :money, code: :JRSRWKSC, value: 1_00,
      description: 'Staff Conference Junior Senior' },

    # Hot Lunches
    hot_lunch_week_0: { value_type: :money, code: :HL1, value: 1_00,
      description: 'Cost of the Week 1 Hot Lunches' },
    hot_lunch_week_1: { value_type: :money, code: :HL2, value: 2_00,
      description: 'Cost of the Week 2 Hot Lunches' },
    hot_lunch_week_2: { value_type: :money, code: :HL3, value: 4_00,
      description: 'Cost of the Week 3 Hot Lunches' },
    hot_lunch_week_3: { value_type: :money, code: :HL4, value: 8_00,
      description: 'Cost of the Week 4 Hot Lunches' },
    hot_lunch_week_4: { value_type: :money, code: :HLSC, value: 16_00,
      description: 'Cost of the Staff Conference Hot Lunches' },
  }.freeze

  def initialize
    @existing = UserVariable.cached_values.keys
  end

  def call
    RECORDS.each { |name, attributes| create_unless_exists(name, attributes) }
  end

  private

  def create_unless_exists(short_name, attributes = {})
    return if UserVariable.exists?(short_name: short_name)

    UserVariable.create!(
      attributes.merge(short_name: short_name)
    )
  end
end
