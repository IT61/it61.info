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

ActiveRecord::Schema.define(version: 20160705080503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_participations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_participations", ["event_id"], name: "index_event_participations_on_event_id", using: :btree
  add_index "event_participations", ["user_id"], name: "index_event_participations_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",                                         null: false
    t.text     "description",                                   null: false
    t.string   "title_image"
    t.integer  "organizer_id",                                  null: false
    t.boolean  "published",                     default: false
    t.datetime "published_at"
    t.boolean  "subscribers_notification_send", default: false
    t.datetime "started_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "place_id"
    t.string   "extra_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "places", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "address",    null: false
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "places", ["address"], name: "index_places_on_address", using: :btree
  add_index "places", ["title"], name: "index_places_on_title", using: :btree

  create_table "social_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "link"
  end

  add_index "social_accounts", ["user_id"], name: "index_social_accounts_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: ""
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "name"
    t.integer  "role",                             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "phone"
    t.string   "normalized_phone"
    t.boolean  "email_reminders",                  null: false
    t.boolean  "sms_reminders",                    null: false
    t.boolean  "subscribed",                       null: false
    t.string   "remember_token"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["email_reminders"], name: "index_users_on_email_reminders", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["sms_reminders"], name: "index_users_on_sms_reminders", using: :btree
  add_index "users", ["subscribed"], name: "index_users_on_subscribed", using: :btree

end
