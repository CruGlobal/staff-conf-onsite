require 'test_helper'

class ApplyCostAdjustmentsTest < InteractorTestCase
  setup do
    @person = create :attendee
    @cost = Money.new(1_000_00) # $1,000.00
  end

  test '1 price adjustment' do
    @service = create_service price_cents: 250_00

    @result = @service.tap(&:run!).context
    assert_context Money.new(750_00), @result, :new_cost
  end

  test '2 price adjustments' do
    @service = create_service({price_cents: 250_00}, {price_cents: 1_00})

    @result = @service.tap(&:run!).context
    assert_context Money.new(749_00), @result, :new_cost
  end

  test '1 percent adjustment' do
    @service = create_service percent: 50.0

    @result = @service.tap(&:run!).context
    assert_context Money.new(500_00), @result, :new_cost
  end

  test '2 percent adjustments' do
    @service = create_service({percent: 50.0}, {percent: 25.0})

    @result = @service.tap(&:run!).context
    assert_context Money.new(250_00), @result, :new_cost
  end

  test '1 price adjustment and 1 percent adjustment' do
    @service = create_service({price_cents: 150_00}, {percent: 50.0})

    @result = @service.tap(&:run!).context
    assert_context Money.new(350_00), @result, :new_cost
  end

  test '1 price adjustment, negative expected' do
    @service = create_service price_cents: 1_250_00

    @result = @service.tap(&:run!).context
    assert_context Money.new(-250_00), @result, :new_cost
  end

  test '2 percent adjustments, negative expected' do
    @service = create_service({percent: 50.0}, {percent: 85.0})

    @result = @service.tap(&:run!).context
    assert_context Money.new(-350_00), @result, :new_cost
  end

  private

  def create_service(*args)
    args.each do |attrs|
      create :cost_adjustment, attrs.reverse_merge(person_id: @person.id)
    end

    ApplyCostAdjustments.new(cost: @cost,
                             cost_adjustments: @person.cost_adjustments)
  end
end
