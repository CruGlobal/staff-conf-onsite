class AddGtkyIsFollowerToCruStudentMedicalHistories < ActiveRecord::Migration
  def change
    add_column :cru_student_medical_histories, :gtky_is_follower, :string
  end
end
