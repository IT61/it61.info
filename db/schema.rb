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

ActiveRecord::Schema.define(version: 20141105105800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "link"
  end

  create_table "companies", force: true do |t|
    t.text     "title",                       null: false
    t.text     "description"
    t.integer  "founder_id",                  null: false
    t.string   "logo_image"
    t.text     "contacts"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",   default: false
  end

  add_index "companies", ["founder_id"], name: "index_companies_on_founder_id", using: :btree

  create_table "company_members", force: true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "company_members", ["company_id"], name: "index_company_members_on_company_id", using: :btree
  add_index "company_members", ["user_id"], name: "index_company_members_on_user_id", using: :btree

  create_table "event_participations", force: true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "event_participations", ["deleted_at"], name: "index_event_participations_on_deleted_at", using: :btree
  add_index "event_participations", ["event_id"], name: "index_event_participations_on_event_id", using: :btree
  add_index "event_participations", ["user_id"], name: "index_event_participations_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title",                                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
    t.boolean  "published",                    default: false
    t.text     "description"
    t.datetime "started_at"
    t.string   "title_image"
    t.string   "place"
    t.datetime "deleted_at"
    t.boolean  "published_to_google_calendar", default: false
    t.string   "google_calendar_id"
  end

  add_index "events", ["deleted_at"], name: "index_events_on_deleted_at", using: :btree
  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "phone"
    t.string   "normalized_phone"
    t.boolean  "send_email_reminders",   default: true
    t.boolean  "send_sms_reminders",     default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["send_email_reminders"], name: "index_users_on_send_email_reminders", using: :btree
  add_index "users", ["send_sms_reminders"], name: "index_users_on_send_sms_reminders", using: :btree

end
