class ChangeCruStudentMedicalHistoryColumnsToArray < ActiveRecord::Migration
  COLUMNS = [:gtky_challenges, :cs_health_misc, :cs_vip_comm, :cs_vip_stress].freeze

  def up
    COLUMNS.each do |column|
      remove_column :cru_student_medical_histories, column
      add_column :cru_student_medical_histories, column, :string, array: true, default: []
    end
  end

  def down
    COLUMNS.each do |column|
      change_column :cru_student_medical_histories, column, :string, array: false
    end
  end
end
