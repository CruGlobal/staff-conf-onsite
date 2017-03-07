class SeedUserVariables
  RECORDS = {
    childcare_week_1: { value_type: :money, code: :CCWK1, value: 1_00,
      description: 'Week 1 Childcare' },
    rec_center_daily: { value_type: :money, code: :RP, value: 1_00,
      description: 'Rec Center Pass Per Day' },
    child_age_cutoff: { value_type: :date, code: :CCD, value: '2017-07-01',
      description: 'Child Age Cut-off Date' },

    test_string: { value_type: :string, code: :TEST_STRING, value: 'Hello, world',
      description: 'A test String variable' },
    test_money:  { value_type: :money, code: :TEST_MONEY, value: '123_45',
      description: 'A test Money variable' },
    test_date:   { value_type: :date, code: :TEST_DATE, value: '2017-02-03',
      description: 'A test Date variable' },
    test_number: { value_type: :number, code: :TEST_NUMBER, value: '123.45',
      description: 'A test Number variable' },
    test_html:   { value_type: :html, code: :TEST_HTML, value: '<b>Hello</b>, world',
      description: 'A test HTML variable' },
  }.freeze

  def initialize
    @existing = UserVariable.cached_values.keys
  end

  def call
    RECORDS.each { |name, attributes| create_unless_exists(name, attributes) }
  end

  private

  def create_unless_exists(short_name, attributes = {})
    return if @existing.include?(short_name)

    UserVariable.create!(
      attributes.merge(short_name: short_name)
    )
  end
end
