class SyncChildcareAndCruStudentMedicalFields < ActiveRecord::Migration[7.1]
  def change
    # --- Remove outdated columns ---
    remove_column :childcare_medical_histories, :medi_allergy, :text
    remove_column :childcare_medical_histories, :allergies, :string, array: true
    remove_column :childcare_medical_histories, :restriction_certified, :string, array: true
    remove_column :childcare_medical_histories, :vip_developmental_age, :integer
    remove_column :childcare_medical_histories, :other_special_needs, :text
    remove_column :childcare_medical_histories, :cc_vip_sitting, :text   # will re-add as string    

    remove_column :cru_student_medical_histories, :med_allergy_multi, :string, array: true

    # --- Add updated/renamed fields ---
    add_column :childcare_medical_histories, :cc_medi_allergy, :text
    add_column :childcare_medical_histories, :cc_allergies, :string, array: true, default: [], null: true
    add_column :childcare_medical_histories, :cc_restriction_certified, :string, array: true, default: [], null: true
    add_column :childcare_medical_histories, :cc_vip_sitting, :string
    add_column :childcare_medical_histories, :cc_other_special_needs, :string
    add_column :childcare_medical_histories, :cc_vip_staff_administered_meds, :string
    add_column :childcare_medical_histories, :cc_vip_developmental_age, :string    

    add_column :cru_student_medical_histories, :cs_allergies, :string, array: true, default: [], null: true
    add_column :cru_student_medical_histories, :cs_restriction_certified, :string, array: true, default: [], null: true
    add_column :cru_student_medical_histories, :cs_other_special_needs, :text
    add_column :cru_student_medical_histories, :cs_vip_staff_administered_meds, :text
    add_column :cru_student_medical_histories, :cs_chronic_health, :string, array: true, default: [], null: true
    add_column :cru_student_medical_histories, :cs_medications, :string
    add_column :cru_student_medical_histories, :cs_vip_developmental_age, :string
    add_column :cru_student_medical_histories, :cs_restrictions, :string
  end
end
