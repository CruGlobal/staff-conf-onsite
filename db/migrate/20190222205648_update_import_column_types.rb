class UpdateImportColumnTypes < ActiveRecord::Migration
  def up
    change_column :childcare_medical_histories, :allergy, :string
    change_column :childcare_medical_histories, :food_intolerance, :string
    change_column :childcare_medical_histories, :chronic_health_addl, :string
    change_column :childcare_medical_histories, :medications, :string
    change_column :childcare_medical_histories, :vip_meds, :string
    change_column :childcare_medical_histories, :vip_strengths, :string
    change_column :childcare_medical_histories, :vip_challenges, :string
    change_column :childcare_medical_histories, :vip_mobility, :string
    change_column :childcare_medical_histories, :vip_walk, :string
    change_column :childcare_medical_histories, :vip_comm, :text
    change_column :childcare_medical_histories, :vip_stress_addl, :string
    change_column :childcare_medical_histories, :vip_stress_behavior, :text
    change_column :childcare_medical_histories, :vip_hobby, :string
    change_column :childcare_medical_histories, :vip_buddy, :string

    change_column :cru_student_medical_histories, :gtky_small_group_friend, :string
    change_column :cru_student_medical_histories, :gtky_activities, :string
    change_column :cru_student_medical_histories, :gtky_gain, :string
    change_column :cru_student_medical_histories, :gtky_growth, :string
    change_column :cru_student_medical_histories, :gtky_addl_info, :string
    change_column :cru_student_medical_histories, :cs_vip_meds, :string
    change_column :cru_student_medical_histories, :cs_vip_strengths, :text
    change_column :cru_student_medical_histories, :cs_vip_challenges, :string
    change_column :cru_student_medical_histories, :cs_vip_mobility, :string
    change_column :cru_student_medical_histories, :cs_vip_walk, :string
    change_column :cru_student_medical_histories, :cs_vip_stress_addl, :string
    change_column :cru_student_medical_histories, :cs_vip_hobby, :string
    change_column :cru_student_medical_histories, :cs_vip_buddy, :string
  end

  def down
    change_column :childcare_medical_histories, :allergy, :text
    change_column :childcare_medical_histories, :food_intolerance, :text
    change_column :childcare_medical_histories, :chronic_health_addl, :text
    change_column :childcare_medical_histories, :medications, :text
    change_column :childcare_medical_histories, :vip_meds, :text
    change_column :childcare_medical_histories, :vip_strengths, :text
    change_column :childcare_medical_histories, :vip_challenges, :text
    change_column :childcare_medical_histories, :vip_mobility, :text
    change_column :childcare_medical_histories, :vip_walk, :text
    change_column :childcare_medical_histories, :vip_comm, :string
    change_column :childcare_medical_histories, :vip_stress_addl, :text
    change_column :childcare_medical_histories, :vip_stress_behavior, :string
    change_column :childcare_medical_histories, :vip_hobby, :text
    change_column :childcare_medical_histories, :vip_buddy, :text

    change_column :cru_student_medical_histories, :gtky_small_group_friend, :text
    change_column :cru_student_medical_histories, :gtky_activities, :text
    change_column :cru_student_medical_histories, :gtky_gain, :text
    change_column :cru_student_medical_histories, :gtky_growth, :text
    change_column :cru_student_medical_histories, :gtky_addl_info, :text
    change_column :cru_student_medical_histories, :cs_vip_meds, :text
    change_column :cru_student_medical_histories, :cs_vip_strengths, :string
    change_column :cru_student_medical_histories, :cs_vip_challenges, :text
    change_column :cru_student_medical_histories, :cs_vip_mobility, :text
    change_column :cru_student_medical_histories, :cs_vip_walk, :text
    change_column :cru_student_medical_histories, :cs_vip_stress_addl, :text
    change_column :cru_student_medical_histories, :cs_vip_hobby, :text
    change_column :cru_student_medical_histories, :cs_vip_buddy, :text
  end
end
