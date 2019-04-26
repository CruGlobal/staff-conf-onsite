class AddPeopleRefToCruStudentMedicalHistory < ActiveRecord::Migration
  def change
    add_reference :cru_student_medical_histories, :person, index: true, foreign_key: true
  end
end
