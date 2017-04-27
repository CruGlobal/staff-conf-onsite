require 'test_helper'

class RecPass::SumPersonRecPassCostTest < InteractorTestCase
  setup do
    @person = create :attendee
    @dorm_unit = create :dormitory_unit
    @date = Date.parse('2017-01-01')

    @service = RecPass::SumPersonCost.new(person: @person)
  end

  stub_user_variable rec_center_daily: Money.new(123_45)

  test 'not applicable' do
    update_dates(nil, nil)

    @result = run_service

    assert_context expected(Money.empty), @result, :charges
  end

  test '1 day' do
    update_dates(@date, @date)

    @result = run_service

    assert_context expected(123_45 * 1), @result, :charges
  end

  test '2 days' do
    update_dates(@date, @date + 1.day)

    @result = run_service

    assert_context expected(123_45 * 2), @result, :charges
  end

  test '1 day, in a dorm' do
    update_dates(@date, @date)
    create :stay, housing_unit: @dorm_unit, person: @person, arrived_at: @date,
                  departed_at: @date
    @person.reload

    @result = run_service

    assert_context expected(0), @result, :charges
  end

  test '2 days, 1 in a dorm' do
    update_dates(@date, @date + 1.day)
    create :stay, housing_unit: @dorm_unit, person: @person, arrived_at: @date,
                  departed_at: @date
    @person.reload

    @result = run_service

    assert_context expected(123_45 * 1), @result, :charges
  end

  private

  def run_service
    @service.tap(&:run!).context
  end

  def expected(price_cents)
    { rec_center: Money.new(price_cents) }
  end

  def update_dates(start, finish)
    @person.update!(
      rec_center_pass_started_at: start,
      rec_center_pass_expired_at: finish
    )
  end
end
