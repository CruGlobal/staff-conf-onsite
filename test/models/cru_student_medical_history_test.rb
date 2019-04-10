require 'test_helper'

class CruStudentMedicalHistoryTest < ActiveSupport::TestCase
  setup do
    @child = Child.new(first_name: 'test-name')
    @cru_student = CruStudentMedicalHistory.create(parent_agree: 'Yes')
  end

  test 'cru student agree' do
    assert_equal 'test-name', @child.first_name
    @child.cru_student_medical_history = @cru_student
    assert_equal 'Yes', @child.cru_student_medical_history.parent_agree
  end

  test 'mult select attribute' do
    @cru_student.gtky_challenges = ['Death', 'Other']
    @cru_student.save!
    @cru_student.reload
    assert_equal ['Death', 'Other'], @cru_student.gtky_challenges
  end
end
