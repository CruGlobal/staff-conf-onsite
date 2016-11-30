# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161130080106) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "childcares", force: :cascade do |t|
    t.string   "title"
    t.string   "teachers"
    t.string   "address"
    t.integer  "cost"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conference_attendances", force: :cascade do |t|
    t.integer  "conference_id"
    t.integer  "attendee_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "conference_attendances", ["attendee_id"], name: "index_conference_attendances_on_attendee_id"
  add_index "conference_attendances", ["conference_id"], name: "index_conference_attendances_on_conference_id"

  create_table "conferences", force: :cascade do |t|
    t.integer  "price_cents"
    t.string   "name"
    t.text     "description"
    t.date     "start_at"
    t.date     "end_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "cost_adjustments", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "price_cents", null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "cost_type",   null: false
  end

  add_index "cost_adjustments", ["person_id"], name: "index_cost_adjustments_on_person_id"

  create_table "cost_code_charges", force: :cascade do |t|
    t.integer  "cost_code_id"
    t.integer  "max_days",           default: 0
    t.integer  "adult_cents",        default: 0
    t.integer  "teen_cents",         default: 0
    t.integer  "child_cents",        default: 0
    t.integer  "infant_cents",       default: 0
    t.integer  "child_meal_cents",   default: 0
    t.integer  "single_delta_cents", default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "cost_code_charges", ["cost_code_id", "max_days"], name: "index_cost_code_charges_on_cost_code_id_and_max_days", unique: true
  add_index "cost_code_charges", ["cost_code_id"], name: "index_cost_code_charges_on_cost_code_id"

  create_table "cost_codes", force: :cascade do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.integer  "min_days",    default: 1, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "course_attendances", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "attendee_id"
    t.string   "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "course_attendances", ["attendee_id"], name: "index_course_attendances_on_attendee_id"
  add_index "course_attendances", ["course_id", "attendee_id"], name: "index_course_attendances_on_course_id_and_attendee_id", unique: true
  add_index "course_attendances", ["course_id"], name: "index_course_attendances_on_course_id"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "price_cents",     null: false
    t.string   "instructor"
    t.string   "week_descriptor"
    t.integer  "ibs_code"
    t.string   "location"
  end

  create_table "families", force: :cascade do |t|
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "street"
    t.string   "country_code", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name",              null: false
    t.string   "staff_number",           null: false
  end

  create_table "housing_facilities", force: :cascade do |t|
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "street"
    t.string   "country_code", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "housing_type",           default: 0, null: false
  end

  create_table "housing_preferences", force: :cascade do |t|
    t.integer  "family_id",                   null: false
    t.integer  "housing_type",                null: false
    t.string   "location1"
    t.string   "location2"
    t.string   "location3"
    t.integer  "beds_count"
    t.text     "roommates"
    t.date     "confirmed_at"
    t.integer  "children_count"
    t.integer  "bedrooms_count"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "single_room"
    t.string   "other_family"
    t.boolean  "accepts_non_air_conditioned"
  end

  create_table "housing_units", force: :cascade do |t|
    t.integer  "housing_facility_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "housing_units", ["housing_facility_id", "name"], name: "index_housing_units_on_housing_facility_id_and_name", unique: true

  create_table "meal_exemptions", force: :cascade do |t|
    t.date     "date"
    t.integer  "person_id"
    t.string   "meal_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meal_exemptions", ["person_id", "date", "meal_type"], name: "index_meal_exemptions_on_person_id_and_date_and_meal_type", unique: true

  create_table "ministries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       null: false
    t.integer  "parent_id"
  end

  add_index "ministries", ["code"], name: "index_ministries_on_code", unique: true
  add_index "ministries", ["parent_id"], name: "index_ministries_on_parent_id"

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "emergency_contact"
    t.string   "phone"
    t.date     "birthdate"
    t.string   "student_number"
    t.string   "gender"
    t.string   "department"
    t.integer  "family_id"
    t.integer  "ministry_id"
    t.string   "type"
    t.string   "childcare_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_bed",         default: true
    t.boolean  "parent_pickup"
    t.string   "childcare_weeks",   default: ""
    t.integer  "childcare_id"
    t.string   "grade_level"
  end

  add_index "people", ["childcare_id"], name: "index_people_on_childcare_id"
  add_index "people", ["student_number"], name: "index_people_on_student_number"
  add_index "people", ["type"], name: "index_people_on_type"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.string   "cas_ticket"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["cas_ticket"], name: "index_sessions_on_cas_ticket"
  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "stays", force: :cascade do |t|
    t.integer  "person_id",                        null: false
    t.integer  "housing_unit_id"
    t.date     "arrived_at"
    t.date     "departed_at"
    t.boolean  "single_occupancy", default: false, null: false
    t.boolean  "no_charge",        default: false, null: false
    t.boolean  "waive_minimum",    default: false, null: false
    t.integer  "percentage",       default: 100,   null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "stays", ["housing_unit_id"], name: "index_stays_on_housing_unit_id"
  add_index "stays", ["person_id"], name: "index_stays_on_person_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",      default: "",        null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "role",       default: "general"
    t.string   "guid",                           null: false
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",                     null: false
    t.integer  "item_id",                       null: false
    t.string   "event",                         null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 1073741823
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"

end
