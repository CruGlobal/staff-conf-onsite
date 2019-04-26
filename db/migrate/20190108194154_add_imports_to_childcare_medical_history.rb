class AddImportsToChildcareMedicalHistory < ActiveRecord::Migration
  def change
    add_column :childcare_medical_histories, :chronic_health, :string
    add_column :childcare_medical_histories, :chronic_health_addl, :text
    add_column :childcare_medical_histories, :medications, :text
    add_column :childcare_medical_histories, :immunizations, :string
    add_column :childcare_medical_histories, :health_misc, :string
    add_column :childcare_medical_histories, :restrictions, :text
    add_column :childcare_medical_histories, :vip_meds, :text
    add_column :childcare_medical_histories, :vip_dev, :text
    add_column :childcare_medical_histories, :vip_strengths, :text
    add_column :childcare_medical_histories, :vip_challenges, :text
    add_column :childcare_medical_histories, :vip_mobility, :text
    add_column :childcare_medical_histories, :vip_walk, :text
    add_column :childcare_medical_histories, :vip_comm, :string
    add_column :childcare_medical_histories, :vip_comm_addl, :text
    add_column :childcare_medical_histories, :vip_comm_small, :text
    add_column :childcare_medical_histories, :vip_comm_large, :text
    add_column :childcare_medical_histories, :vip_comm_directions, :text
    add_column :childcare_medical_histories, :vip_stress, :string
    add_column :childcare_medical_histories, :vip_stress_addl, :text
    add_column :childcare_medical_histories, :vip_stress_behavior, :text
    add_column :childcare_medical_histories, :vip_calm, :text
    add_column :childcare_medical_histories, :vip_hobby, :text
    add_column :childcare_medical_histories, :vip_buddy, :text
    add_column :childcare_medical_histories, :vip_addl_info, :text
    add_column :childcare_medical_histories, :sunscreen_self, :string
    add_column :childcare_medical_histories, :sunscreen_assisted, :string
    add_column :childcare_medical_histories, :sunscreen_provided, :string
  end
end
