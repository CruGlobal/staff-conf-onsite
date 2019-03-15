class AddGtkyAddlChallengesToCruStudentMedicalHistories < ActiveRecord::Migration
  def change
    add_column :cru_student_medical_histories, :gtky_addl_challenges, :text
  end
end
