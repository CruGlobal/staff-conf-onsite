require 'test_helper'

class Childcare::SumCostsTest < InteractorTestCase
  setup do
    @child = create :child, grade_level: :grade1, childcare_deposit: false
    @service = Childcare::SumCosts.new(child: @child)
  end

  stub_user_variable childcare_week_0:  Money.new(1_00),
                     childcare_week_1:  Money.new(2_00),
                     childcare_week_2:  Money.new(4_00),
                     childcare_week_3:  Money.new(8_00),
                     childcare_week_4:  Money.new(16_00),
                     junior_senior_week_0:  Money.new(32_00),
                     junior_senior_week_1:  Money.new(64_00),
                     junior_senior_week_2:  Money.new(128_00),
                     junior_senior_week_3:  Money.new(256_00),
                     junior_senior_week_4:  Money.new(512_00),
                     childcare_deposit: Money.new(32_00)

  test '0 weeks' do
    @child.update!(childcare_weeks: [])
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.empty), @result, :charges
  end

  test '1 week' do
    @child.update!(childcare_weeks: [3])
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(8_00)), @result, :charges
  end

  test '2 weeks' do
    @child.update!(childcare_weeks: [1, 2])
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(6_00)), @result, :charges
  end

  test '2 weeks + deposit' do
    @child.update!(childcare_weeks: [1, 2], childcare_deposit: true)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(38_00)), @result, :charges
  end

  test 'junior/senior 0 weeks' do
    @child.update!(grade_level: :grade9, childcare_weeks: [])
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.empty), @result, :charges
  end

  test 'junior/senior 1 week' do
    @child.update!(grade_level: :grade9, childcare_weeks: [3])
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(256_00)), @result, :charges
  end

  test 'junior/senior 2 weeks' do
    @child.update!(grade_level: :grade9, childcare_weeks: [1, 2])
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(192_00)), @result, :charges
  end

  test 'junior/senior 2 weeks + deposit' do
    @child.update!(grade_level: :grade9, childcare_weeks: [1, 2],
                   childcare_deposit: true)
    @result = @service.tap(&:run!).context
    assert_context expected_price(Money.new(224_00)), @result, :charges
  end

  private

  def expected_price(price)
    { childcare_jr_sr: price }
  end
end
