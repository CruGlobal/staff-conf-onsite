require 'test_helper'

class StayTest < ActiveSupport::TestCase
  setup do
    @stay = Stay.new(arrived_at: 6.days.ago, departed_at: 3.days.ago)
  end

  test '#length_of_stay' do
    assert_equal 3, @stay.length_of_stay
    @stay.departed_at = 6.days.ago + 1.hour
    assert_equal 1, @stay.length_of_stay
  end
end
