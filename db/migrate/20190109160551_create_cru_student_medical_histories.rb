class CreateCruStudentMedicalHistories < ActiveRecord::Migration
  def change
    create_table :cru_student_medical_histories do |t|
      t.string :parent_agree

      t.timestamps null: false
    end
  end
end
