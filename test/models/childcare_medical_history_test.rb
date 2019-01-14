require 'test_helper'

class ChildcareMedicalHistoryTest < ActiveSupport::TestCase
  setup do
    @person = Person.new(first_name: 'test-name')
    @childcare = ChildcareMedicalHistory.create(allergy: 'allergy-text')
  end

  test 'childcare medical' do
    assert_equal 'test-name', @person.first_name
    @person.childcare_medical_history = @childcare
    assert_equal 'allergy-text', @person.childcare_medical_history.allergy
  end
end
