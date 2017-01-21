require 'test_helper'

class StayTest < ActiveSupport::TestCase
  setup do
    @person = Person.new(birthdate: 20.years.ago)
  end

  test '#age' do
    assert_equal 20, @person.age
  end
end
