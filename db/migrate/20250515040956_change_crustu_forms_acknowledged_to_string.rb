class ChangeCrustuFormsAcknowledgedToString < ActiveRecord::Migration[7.1]
  def up
    change_column :cru_student_medical_histories, :crustu_forms_acknowledged, :string, default: '', null: true
    add_column :cru_student_medical_histories, :cs_chronic_health_addl, :text
  end

  def down
    # Revert crustu_forms_acknowledged back to string array    
    remove_column :cru_student_medical_histories, :cs_chronic_health_addl
  end
end
