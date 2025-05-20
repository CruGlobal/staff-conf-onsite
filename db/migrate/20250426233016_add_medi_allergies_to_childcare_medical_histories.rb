class AddMediAllergiesToChildcareMedicalHistories < ActiveRecord::Migration[7.1]
  def change
    add_column :childcare_medical_histories, :cc_medi_allergy, :text, null: true
    add_column :childcare_medical_histories, :cc_allergies, :string, array: true, default: [], null: true
    add_column :childcare_medical_histories, :non_immunizations, :string, array: true, default: [], null: true
    add_column :childcare_medical_histories, :cc_restriction_certified, :string, array: true, default: [], null: true    
    add_column :childcare_medical_histories, :cc_vip_sitting, :string, null: true
    add_column :childcare_medical_histories, :cc_other_special_needs, :string, null: true
    add_column :childcare_medical_histories, :cc_vip_staff_administered_meds, :string, null: true
    add_column :childcare_medical_histories, :cc_vip_developmental_age, :string, null: true

    
    add_column :cru_student_medical_histories, :crustu_forms_acknowledged, :string, array: true, default: [], null: true
    add_column :cru_student_medical_histories, :cs_allergies, :string, array: true, default: [], null: true
    add_column :cru_student_medical_histories, :cs_restriction_certified, :string, array: true, default: [], null: true        
    add_column :cru_student_medical_histories, :cs_other_special_needs, :text, null: true
    add_column :cru_student_medical_histories, :cs_vip_staff_administered_meds, :text, null: true
    add_column :cru_student_medical_histories, :cs_chronic_health, :string, array: true, default: [], null: true    
    add_column :cru_student_medical_histories, :cs_medications, :string, null: true   
    add_column :cru_student_medical_histories, :cs_vip_developmental_age, :string, null: true
    add_column :cru_student_medical_histories, :cs_restrictions, :string, null: true

    add_column :people, :tracking_id, :string, null: true

  end
end