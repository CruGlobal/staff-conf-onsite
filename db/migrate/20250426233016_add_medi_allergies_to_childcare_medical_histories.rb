class AddMediAllergiesToChildcareMedicalHistories < ActiveRecord::Migration[7.1]
  def change
    add_column :childcare_medical_histories, :medi_allergy, :text, null: true
    add_column :childcare_medical_histories, :allergies, :string, array: true, default: [], null: true
    add_column :childcare_medical_histories, :non_immunizations, :string, array: true, default: [], null: true
    add_column :childcare_medical_histories, :restriction_certified, :string, array: true, default: [], null: true    
    add_column :childcare_medical_histories, :vip_developmental_age, :integer, null: true
    add_column :childcare_medical_histories, :cc_vip_sitting, :text, null: true

    add_column :cru_student_medical_histories, :med_allergy_multi, :string, array: true, default: [], null: true   
    add_column :cru_student_medical_histories, :crustu_forms_acknowledged, :string, array: true, default: [], null: true
    add_column :people, :tracking_id, :string, null: true

  end
end
