class ChangePersonIdToChildIdOnCruStudentMedicalHistory < ActiveRecord::Migration
  def change
    rename_column :cru_student_medical_histories, :person_id, :child_id
  end
end
