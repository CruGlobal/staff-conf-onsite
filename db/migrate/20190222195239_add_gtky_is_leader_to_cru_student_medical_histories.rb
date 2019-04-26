class AddGtkyIsLeaderToCruStudentMedicalHistories < ActiveRecord::Migration
  def change
    add_column :cru_student_medical_histories, :gtky_is_leader, :string
  end
end
