ActiveAdmin.register Child do
  partial_view :index, :show, form: Person::FORM_OPTIONS

  menu parent: 'People', priority: 3

  includes :family

  scope :all, default: true
  scope :in_kidscare

  # We create through Families#show
  config.remove_action_item :new
  config.remove_action_item :new_show

  permit_params(
    :first_name, :last_name, :birthdate, :gender, :family_id, :parent_pickup,
    :needs_bed, :grade_level, :childcare_id, :arrived_at, :departed_at,
    :name_tag_first_name, :name_tag_last_name, :childcare_deposit,
    :childcare_comment, :rec_pass_start_at, :rec_pass_end_at,
    childcare_weeks: [], hot_lunch_weeks: [], cost_adjustments_attributes: %i[
      id _destroy description person_id price percent cost_type
    ],
    childcare_medical_history_attributes: %i[
      id _destroy date allergy food_intolerance chronic_health chronic_health_addl medications immunizations
      health_misc restrictions vip_meds vip_dev vip_strengths vip_challenges vip_mobility vip_walk vip_comm
      vip_comm_addl vip_comm_small vip_comm_large vip_comm_directions vip_stress vip_stress_addl
      vip_stress_behavior vip_calm vip_hobby vip_buddy vip_addl_info sunscreen_self sunscreen_assisted
      sunscreen_provided
    ],
    cru_student_medical_history_attributes: %i[
      id _destroy date parent_agree gsky_lunch gsky_signout gsky_sibling_signout gsky_sibling
      gsky_small_group_friend gsky_musical gsky_activities gsky_gain gsky_growth gsky_addl_info
      gsky_challenges gsky_large_groups gsky_small_groups gsky_leader gsky_follower gsky_friends gsky_hesitant
      gsky_active gsky_reserved gsky_boundaries gsky_authority gsky_adapts gsky_allergies med_allergies
      food_allergies other_allergies health_concerns asthma migraines severe_allergy anorexia diabetes
      altitude concerns_misc cs_health_misc cs_vip_meds cs_vip_dev cs_vip_strengths cs_vip_challenges
      cs_vip_mobility cs_vip_walk cs_vip_comm cs_vip_comm_addl cs_vip_comm_small cs_vip_comm_large
      cs_vip_comm_directions cs_vip_stress cs_vip_stress_addl cs_vip_stress_behavior
      cs_vip_calm cs_vip_sitting cs_vip_hobby cs_vip_buddy cs_vip_addl_info
    ],
    meal_exemptions_attributes: %i[
      id _destroy date meal_type
    ],
    stays_attributes: %i[
      id _destroy housing_unit_id arrived_at departed_at single_occupancy
      no_charge waive_minimum percentage comment
    ]
  )

  filter :first_name
  filter :last_name
  filter :birthdate
  filter :gender
  filter :parent_pickup
  filter :needs_bed
  filter :arrived_at
  filter :departed_at
  filter :childcare_class

  action_item :import_spreadsheet, only: :index do
    link_to 'Import Spreadsheet', new_spreadsheet_families_path if authorized?(:import, Family)
  end
end
