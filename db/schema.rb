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

ActiveRecord::Schema.define(version: 20160926164300) do

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
    t.date     "start_at"
    t.date     "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "families", force: :cascade do |t|
    t.string   "phone"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "street"
    t.string   "country_code", limit: 2
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "meals", force: :cascade do |t|
    t.date     "date"
    t.integer  "attendee_id"
    t.string   "meal_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meals", ["attendee_id", "date", "meal_type"], name: "index_meals_on_attendee_id_and_date_and_meal_type", unique: true

  create_table "ministries", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "emergency_contact"
    t.string   "phone"
    t.date     "birthdate"
    t.string   "student_number"
    t.string   "staff_number"
    t.string   "gender"
    t.string   "department"
    t.integer  "family_id"
    t.integer  "ministry_id"
    t.string   "type"
    t.string   "childcare_grade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "people", ["student_number"], name: "index_people_on_student_number"
  add_index "people", ["type"], name: "index_people_on_type"

  create_table "rooms", force: :cascade do |t|
    t.integer  "housing_facility_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["housing_facility_id", "number"], name: "index_rooms_on_housing_facility_id_and_number", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "role",                   default: "general"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
