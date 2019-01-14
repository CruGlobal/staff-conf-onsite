require 'test_helper'

class CruStudentMedicalHistoryTest < ActiveSupport::TestCase
  setup do
    @person = Person.new(first_name: 'test-name')
    @cru_student = CruStudentMedicalHistory.create(parent_agree: 'Yes')
  end

  test 'cru student agree' do
    assert_equal 'test-name', @person.first_name
    @person.cru_student_medical_history = @cru_student
    assert_equal 'Yes', @person.cru_student_medical_history.parent_agree
  end
end
