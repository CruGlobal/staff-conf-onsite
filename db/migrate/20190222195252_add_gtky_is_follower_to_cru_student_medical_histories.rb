class AddGtkyIsFollowerToCruStudentMedicalHistories < ActiveRecord::Migration
  def up
    rename_column :cru_student_medical_histories, :gsky_follower, :gtky_is_follower
  end

  def down
    rename_column :cru_student_medical_histories, :gtky_is_follower, :gsky_follower
  end
end
