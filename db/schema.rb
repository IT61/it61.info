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

ActiveRecord::Schema.define(version: 20150220162905) do

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
  end

  add_index "event_participations", ["event_id"], name: "index_event_participations_on_event_id", using: :btree
  add_index "event_participations", ["user_id"], name: "index_event_participations_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "title",                                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
    t.boolean  "published",                     default: false
    t.text     "description"
    t.datetime "started_at"
    t.string   "title_image"
    t.string   "place"
    t.boolean  "published_to_google_calendar",  default: false
    t.string   "google_calendar_id"
    t.boolean  "subscribers_notification_send", default: false
    t.datetime "published_at"
  end

  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree
  add_index "events", ["published_at"], name: "index_events_on_published_at", using: :btree
  add_index "events", ["subscribers_notification_send"], name: "index_events_on_subscribers_notification_send", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "last_login_from_ip_address"
    t.string   "name"
    t.integer  "role"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "avatar_image"
    t.string   "phone"
    t.string   "normalized_phone"
    t.boolean  "email_reminders",                 default: true
    t.boolean  "sms_reminders",                   default: false
    t.boolean  "subscribed"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["email_reminders"], name: "index_users_on_email_reminders", using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["sms_reminders"], name: "index_users_on_sms_reminders", using: :btree
  add_index "users", ["subscribed"], name: "index_users_on_subscribed", using: :btree

end
