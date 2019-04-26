require 'test_helper'

class ChildcareMedicalHistoryTest < ActiveSupport::TestCase
  setup do
    @child = Child.new(first_name: 'test-name')
    @childcare = ChildcareMedicalHistory.create(allergy: 'allergy-text')
  end

  test 'childcare medical' do
    assert_equal 'test-name', @child.first_name
    @child.childcare_medical_history = @childcare
    assert_equal 'allergy-text', @child.childcare_medical_history.allergy
  end

  test 'mult select attribute' do
    @childcare.chronic_health = ['Asthma', 'Other']
    @childcare.save!
    @childcare.reload
    assert_equal ['Asthma', 'Other'], @childcare.chronic_health
  end
end
