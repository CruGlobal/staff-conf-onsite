require 'test_helper'

class SumChildStayCostTest < InteractorTestCase
  setup do

    @child = create :child
    @cost_code = create_cost_code max_days: 100,
                                  adult_cents: 111,
                                  teen_cents: 222,
                                  child_cents: 333,
                                  infant_cents: 444,
                                  child_meal_cents: 555,
                                  single_delta_cents: 666
    @dormitory = create :housing_facility, housing_type: :dormitory,
                                           cost_code: @cost_code
    @unit = create :housing_unit, housing_facility: @dormitory

    @arrived_at = Date.parse('2017-01-01')
    @child.stays.create! housing_unit: @unit, arrived_at: @arrived_at,
                         departed_at: (@arrived_at + 5.days)

    @service = SumChildStayCost.new(child: @child)
  end

  stub_user_variable child_age_cutoff: 6.months.from_now

  test 'adult with no stays' do
    @child.update!(birthdate: 15.years.ago)
    @child.stays.each(&:destroy!)
    @child.reload

    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.empty), @result, :charges
  end

  test 'adult' do
    @child.update!(birthdate: 15.years.ago)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(111 * 5)), @result, :charges
  end

  test 'old teen' do
    @child.update!(birthdate: 14.years.ago)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(222 * 5)), @result, :charges
  end

  test 'young teen' do
    @child.update!(birthdate: 11.years.ago)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(222 * 5)), @result, :charges
  end

  test 'old child, needs bed' do
    @child.update!(birthdate: 10.years.ago, needs_bed: true)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(333 * 5)), @result, :charges
  end

  test 'young child, needs bed' do
    @child.update!(birthdate: 5.years.ago, needs_bed: true)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(333 * 5)), @result, :charges
  end

  test 'infant, needs bed' do
    @child.update!(birthdate: 4.years.ago, needs_bed: true)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(444 * 5)), @result, :charges
  end

  test 'old child, does not need bed' do
    @child.update!(birthdate: 10.years.ago, needs_bed: false)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(555 * 5)), @result, :charges
  end

  test 'young child, does not need bed' do
    @child.update!(birthdate: 5.years.ago, needs_bed: false)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(555 * 5)), @result, :charges
  end

  test 'infant, does not need bed' do
    @child.update!(birthdate: 4.years.ago, needs_bed: false)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(555 * 5)), @result, :charges
  end

  test 'adult staying at 2 dormitories' do
    @child.update!(birthdate: 15.years.ago)
    @other_cost_code = create_cost_code max_days: 100, adult_cents: 112
    @other_dormitory = create :housing_facility, housing_type: :dormitory,
                                                 cost_code: @other_cost_code
    @other_unit = create :housing_unit, housing_facility: @other_dormitory
    @child.stays.create! housing_unit: @other_unit, arrived_at: @arrived_at,
                         departed_at: (@arrived_at + 7.days)

    @result = @service.tap(&:run!).context

    assert_context expected_price(Money.new(111 * 5 + 112 * 7)), @result, :charges
  end

  test 'adult staying at 2 units in 1 dormitory' do
    @child.update!(birthdate: 15.years.ago)
    @other_unit = create :housing_unit, housing_facility: @dormitory
    @child.stays.create! housing_unit: @other_unit, arrived_at: @arrived_at,
                         departed_at: (@arrived_at + 7.days)

    @result = @service.tap(&:run!).context

    assert_context expected_price(Money.new(111 * 5 + 111 * 7)), @result, :charges
  end

  test 'adult staying at 1 dormitory and 1 apartment' do
    @child.update!(birthdate: 15.years.ago)

    @apt_cost_code = create_cost_code max_days: 100, adult_cents: 123
    @apartment = create :housing_facility, housing_type: :apartment,
                                           cost_code: @apt_cost_code
    @unit = create :housing_unit, housing_facility: @dormitory
    @child.stays.create! housing_unit: @other_unit, arrived_at: @arrived_at,
                         departed_at: (@arrived_at + 77.days)

    @result = @service.tap(&:run!).context

    assert_context expected_price(Money.new(111 * 5)), @result, :charges
  end

  test 'adult staying at 2 dorms that cross the charge boundary' do
    @child.update!(birthdate: 15.years.ago)
    @child.stays.each(&:destroy!)
    @child.reload

    create :cost_code_charge, cost_code: @cost_code, max_days: 200,
                              adult_cents: 1_00
    @cost_code.reload

    @child.stays.create! housing_unit: @unit, arrived_at: @arrived_at,
                         departed_at: (@arrived_at + 100.days)
    @child.stays.create! housing_unit: @unit, arrived_at: @arrived_at,
                         departed_at: (@arrived_at + 1.day)

    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(1_00 * 101)), @result, :charges
  end

  private

  def create_cost_code(charge_args)
    create(:cost_code, min_days: 1).tap do |code|
      create :cost_code_charge, charge_args.reverse_merge(cost_code: code)
    end
  end

  def expected_price(price)
    { dorm_child: price }
  end
end
