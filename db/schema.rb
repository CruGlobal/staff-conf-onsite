# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_06_22_171241) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.integer "author_id"
    t.string "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "chargeable_staff_numbers", id: :serial, force: :cascade do |t|
    t.string "staff_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["staff_number"], name: "index_chargeable_staff_numbers_on_staff_number"
  end

  create_table "childcare_envelopes", id: :serial, force: :cascade do |t|
    t.string "envelope_id", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipient_id", null: false
    t.integer "child_id", null: false
    t.index ["envelope_id"], name: "index_childcare_envelopes_on_envelope_id"
  end

  create_table "childcare_medical_histories", id: :serial, force: :cascade do |t|
    t.string "allergy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "child_id"
    t.string "food_intolerance"
    t.string "chronic_health_addl"
    t.string "medications"
    t.text "restrictions"
    t.string "vip_meds"
    t.text "vip_dev"
    t.string "vip_strengths"
    t.string "vip_challenges"
    t.string "vip_mobility"
    t.string "vip_walk"
    t.text "vip_comm_addl"
    t.text "vip_comm_small"
    t.text "vip_comm_large"
    t.text "vip_comm_directions"
    t.string "vip_stress_addl"
    t.text "vip_stress_behavior"
    t.text "vip_calm"
    t.string "vip_hobby"
    t.string "vip_buddy"
    t.text "vip_addl_info"
    t.string "sunscreen_self"
    t.string "sunscreen_assisted"
    t.string "sunscreen_provided"
    t.string "chronic_health", default: [], array: true
    t.string "immunizations", default: [], array: true
    t.string "health_misc", default: [], array: true
    t.string "vip_comm", default: [], array: true
    t.string "vip_stress", default: [], array: true
    t.string "non_immunizations", default: [], array: true
    t.text "cc_medi_allergy"
    t.string "cc_allergies", default: [], array: true
    t.string "cc_vip_sitting"
    t.string "cc_other_special_needs"
    t.string "cc_vip_staff_administered_meds"
    t.string "cc_vip_developmental_age"
    t.string "cc_restriction_certified"
    t.index ["child_id"], name: "index_childcare_medical_histories_on_child_id"
  end

  create_table "childcares", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "teachers"
    t.string "location"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "room"
    t.integer "position"
  end

  create_table "conference_attendances", id: :serial, force: :cascade do |t|
    t.integer "conference_id"
    t.integer "attendee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_id"], name: "index_conference_attendances_on_attendee_id"
    t.index ["conference_id"], name: "index_conference_attendances_on_conference_id"
  end

  create_table "conferences", id: :serial, force: :cascade do |t|
    t.integer "price_cents"
    t.string "name"
    t.text "description"
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "waive_off_campus_facility_fee"
    t.boolean "staff_conference", default: false, null: false
    t.integer "position"
  end

  create_table "cost_adjustments", id: :serial, force: :cascade do |t|
    t.integer "person_id"
    t.integer "price_cents"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cost_type", null: false
    t.decimal "percent", precision: 5, scale: 2
    t.index ["person_id"], name: "index_cost_adjustments_on_person_id"
  end

  create_table "cost_code_charges", id: :serial, force: :cascade do |t|
    t.integer "cost_code_id"
    t.integer "max_days", default: 0
    t.integer "adult_cents", default: 0
    t.integer "teen_cents", default: 0
    t.integer "child_cents", default: 0
    t.integer "infant_cents", default: 0
    t.integer "child_meal_cents", default: 0
    t.integer "single_delta_cents", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cost_code_id", "max_days"], name: "index_cost_code_charges_on_cost_code_id_and_max_days", unique: true
    t.index ["cost_code_id"], name: "index_cost_code_charges_on_cost_code_id"
  end

  create_table "cost_codes", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "min_days", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_attendances", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "attendee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "seminary_credit", default: false
    t.string "grade"
    t.index ["attendee_id"], name: "index_course_attendances_on_attendee_id"
    t.index ["course_id", "attendee_id"], name: "index_course_attendances_on_course_id_and_attendee_id", unique: true
    t.index ["course_id"], name: "index_course_attendances_on_course_id"
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description", null: false
    t.integer "price_cents", null: false
    t.string "instructor", null: false
    t.string "week_descriptor", null: false
    t.integer "ibs_code", null: false
    t.string "location", null: false
    t.integer "position"
  end

  create_table "cru_student_medical_histories", id: :serial, force: :cascade do |t|
    t.string "parent_agree"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "child_id"
    t.string "gtky_lunch"
    t.string "gtky_signout"
    t.string "gtky_sibling_signout"
    t.string "gtky_sibling"
    t.string "gtky_small_group_friend"
    t.string "gtky_musical"
    t.string "gtky_activities"
    t.string "gtky_gain"
    t.string "gtky_growth"
    t.string "gtky_addl_info"
    t.string "gtky_large_groups"
    t.string "gtky_small_groups"
    t.string "gtky_leader"
    t.string "gtky_is_follower"
    t.string "gtky_friends"
    t.string "gtky_hesitant"
    t.string "gtky_active"
    t.string "gtky_reserved"
    t.string "gtky_boundaries"
    t.string "gtky_authority"
    t.string "gtky_adapts"
    t.string "gtky_allergies"
    t.string "med_allergies"
    t.string "food_allergies"
    t.string "other_allergies"
    t.string "health_concerns"
    t.string "asthma"
    t.string "migraines"
    t.string "severe_allergy"
    t.string "anorexia"
    t.string "diabetes"
    t.string "altitude"
    t.string "concerns_misc"
    t.string "cs_vip_meds"
    t.text "cs_vip_dev"
    t.text "cs_vip_strengths"
    t.string "cs_vip_challenges"
    t.string "cs_vip_mobility"
    t.string "cs_vip_walk"
    t.text "cs_vip_comm_addl"
    t.text "cs_vip_comm_small"
    t.text "cs_vip_comm_large"
    t.text "cs_vip_comm_directions"
    t.string "cs_vip_stress_addl"
    t.text "cs_vip_stress_behavior"
    t.text "cs_vip_calm"
    t.text "cs_vip_sitting"
    t.string "cs_vip_hobby"
    t.string "cs_vip_buddy"
    t.text "cs_vip_addl_info"
    t.text "gtky_addl_challenges"
    t.string "gtky_is_leader"
    t.string "gtky_challenges", default: [], array: true
    t.string "cs_health_misc", default: [], array: true
    t.string "cs_vip_comm", default: [], array: true
    t.string "cs_vip_stress", default: [], array: true
    t.string "crustu_forms_acknowledged", default: ""
    t.string "cs_allergies", default: [], array: true
    t.text "cs_other_special_needs"
    t.text "cs_vip_staff_administered_meds"
    t.string "cs_chronic_health", default: [], array: true
    t.string "cs_medications"
    t.string "cs_vip_developmental_age"
    t.string "cs_restrictions"
    t.text "cs_chronic_health_addl"
    t.string "cs_restriction_certified"
    t.index ["child_id"], name: "index_cru_student_medical_histories_on_child_id"
  end

  create_table "families", id: :serial, force: :cascade do |t|
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "address1"
    t.string "country_code", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "last_name", null: false
    t.string "staff_number"
    t.string "address2"
    t.string "import_tag"
    t.integer "primary_person_id"
    t.string "license_plates"
    t.boolean "handicap"
    t.integer "precheck_status", default: 0
    t.datetime "precheck_status_changed_at"
    t.string "county"
    t.string "required_team_action", default: [], array: true
    t.boolean "arrival_scanned"
    t.index ["county"], name: "index_families_on_county"
    t.index ["precheck_status"], name: "index_families_on_precheck_status"
    t.index ["precheck_status_changed_at"], name: "index_families_on_precheck_status_changed_at"
  end

  create_table "grade_levels", id: :serial, force: :cascade do |t|
    t.string "age"
    t.string "description"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hotel_stays", id: :serial, force: :cascade do |t|
    t.text "hotel", null: false
    t.integer "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_hotel_stays_on_family_id", unique: true
  end

  create_table "housing_facilities", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "street"
    t.string "country_code", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "housing_type", default: 0, null: false
    t.integer "cost_code_id"
    t.string "cafeteria"
    t.boolean "on_campus"
    t.string "csu_dorm_code"
    t.string "csu_dorm_block"
    t.integer "position"
    t.index ["cost_code_id"], name: "index_housing_facilities_on_cost_code_id"
  end

  create_table "housing_preferences", id: :serial, force: :cascade do |t|
    t.integer "family_id", null: false
    t.integer "housing_type", null: false
    t.string "location1"
    t.string "location2"
    t.string "location3"
    t.integer "beds_count"
    t.text "roommates"
    t.date "confirmed_at"
    t.integer "children_count"
    t.integer "bedrooms_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "single_room"
    t.string "other_family"
    t.boolean "accepts_non_air_conditioned"
    t.text "comment"
  end

  create_table "housing_units", id: :serial, force: :cascade do |t|
    t.integer "housing_facility_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "occupancy_type"
    t.string "room_type"
    t.index ["housing_facility_id", "name"], name: "index_housing_units_on_housing_facility_id_and_name", unique: true
  end

  create_table "meal_exemptions", id: :serial, force: :cascade do |t|
    t.date "date"
    t.integer "person_id"
    t.string "meal_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["person_id", "date", "meal_type"], name: "index_meal_exemptions_on_person_id_and_date_and_meal_type", unique: true
  end

  create_table "ministries", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "code", null: false
    t.integer "parent_id"
    t.index ["code"], name: "index_ministries_on_code", unique: true
    t.index ["parent_id"], name: "index_ministries_on_parent_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.integer "family_id", null: false
    t.integer "price_cents", null: false
    t.integer "payment_type", null: false
    t.integer "cost_type", null: false
    t.string "business_unit"
    t.string "operating_unit"
    t.string "department_code"
    t.string "project_code"
    t.string "reference"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "comment"
    t.index ["cost_type"], name: "index_payments_on_cost_type"
    t.index ["family_id"], name: "index_payments_on_family_id"
    t.index ["payment_type"], name: "index_payments_on_payment_type"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "emergency_contact"
    t.string "phone"
    t.date "birthdate"
    t.string "student_number"
    t.string "gender"
    t.string "department"
    t.integer "family_id"
    t.integer "ministry_id"
    t.string "type"
    t.string "childcare_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "needs_bed", default: true
    t.boolean "parent_pickup", default: false
    t.string "childcare_weeks", default: ""
    t.integer "childcare_id"
    t.string "grade_level"
    t.date "arrived_at"
    t.date "departed_at"
    t.date "rec_pass_start_at"
    t.date "rec_pass_end_at"
    t.string "hot_lunch_weeks", default: "", null: false
    t.integer "seminary_id"
    t.string "family_tag"
    t.string "tshirt_size"
    t.text "mobility_comment"
    t.text "personal_comment"
    t.text "conference_comment"
    t.boolean "childcare_deposit"
    t.text "childcare_comment"
    t.text "ibs_comment"
    t.string "ethnicity"
    t.date "hired_at"
    t.string "employee_status"
    t.string "caring_department"
    t.string "strategy"
    t.string "assignment_length"
    t.string "pay_chartfield"
    t.string "conference_status"
    t.string "name_tag_last_name"
    t.string "name_tag_first_name"
    t.datetime "conference_status_changed_at"
    t.boolean "forms_approved", default: false
    t.string "middle_name"
    t.integer "spouse_id"
    t.string "forms_approved_by"
    t.string "tracking_id"
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.boolean "childcare_cancellation_fee", default: false, null: false
    t.boolean "childcare_late_fee", default: false, null: false
    t.string "county"
    t.index ["childcare_id"], name: "index_people_on_childcare_id"
    t.index ["middle_name"], name: "index_people_on_middle_name"
    t.index ["seminary_id"], name: "index_people_on_seminary_id"
    t.index ["spouse_id"], name: "index_people_on_spouse_id"
    t.index ["student_number"], name: "index_people_on_student_number"
    t.index ["type"], name: "index_people_on_type"
    t.index ["uuid"], name: "index_people_on_uuid", unique: true
  end

  create_table "precheck_email_tokens", id: false, force: :cascade do |t|
    t.string "token", null: false
    t.integer "family_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["family_id"], name: "index_precheck_email_tokens_on_family_id", unique: true
    t.index ["token"], name: "index_precheck_email_tokens_on_token", unique: true
  end

  create_table "reports", id: :serial, force: :cascade do |t|
    t.string "category", null: false
    t.string "name", null: false
    t.text "query", null: false
    t.string "role", default: "general", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.integer "housing_facility_id"
    t.integer "number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["housing_facility_id", "number"], name: "index_rooms_on_housing_facility_id_and_number", unique: true
  end

  create_table "seminaries", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.integer "course_price_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_seminaries_on_code", unique: true
  end

  create_table "stays", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "housing_unit_id"
    t.date "arrived_at"
    t.date "departed_at"
    t.boolean "single_occupancy", default: false, null: false
    t.boolean "no_charge", default: false, null: false
    t.boolean "waive_minimum", default: false, null: false
    t.integer "percentage", default: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.boolean "no_bed", default: false, null: false
    t.index ["housing_unit_id"], name: "index_stays_on_housing_unit_id"
    t.index ["person_id"], name: "index_stays_on_person_id"
  end

  create_table "upload_jobs", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "filename", null: false
    t.boolean "finished", default: false, null: false
    t.boolean "success"
    t.float "percentage", default: 0.0, null: false
    t.string "stage", default: "queued", null: false
    t.text "html_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "file"
  end

  create_table "user_variables", id: :serial, force: :cascade do |t|
    t.string "code", null: false
    t.string "short_name", null: false
    t.integer "value_type", null: false
    t.string "value", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_user_variables_on_code"
    t.index ["short_name"], name: "index_user_variables_on_short_name"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "general"
    t.string "guid"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "childcare_envelopes", "people", column: "child_id"
  add_foreign_key "childcare_envelopes", "people", column: "recipient_id"
  add_foreign_key "childcare_medical_histories", "people", column: "child_id"
  add_foreign_key "cru_student_medical_histories", "people", column: "child_id"
  add_foreign_key "hotel_stays", "families"
  add_foreign_key "people", "seminaries"
  add_foreign_key "precheck_email_tokens", "families"
end
