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

ActiveRecord::Schema.define(version: 20180217123529) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.string "cover"
    t.integer "organizer_id", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.boolean "subscribers_notification_send", default: false
    t.datetime "started_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendees_limit", default: -1, null: false
    t.string "link"
    t.integer "place_id"
    t.boolean "has_closed_registration", default: false
    t.boolean "has_attendees_limit", default: false, null: false
    t.string "google_calendar_hash"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
    t.index ["place_id"], name: "index_events_on_place_id"
  end

  create_table "events_attendees", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_events_attendees_on_event_id"
    t.index ["user_id", "event_id"], name: "index_events_attendees_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_events_attendees_on_user_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0, null: false
    t.index ["name"], name: "index_groups_on_name"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.index ["group_id"], name: "index_groups_users_on_group_id"
    t.index ["user_id"], name: "index_groups_users_on_user_id"
  end

  create_table "places", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "address", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_places_on_address"
    t.index ["title", "address", "latitude", "longitude"], name: "index_places_on_title_and_address_and_latitude_and_longitude", unique: true
    t.index ["title"], name: "index_places_on_title"
  end

  create_table "social_accounts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.index ["user_id"], name: "index_social_accounts_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: ""
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.text "bio"
    t.string "phone"
    t.string "normalized_phone"
    t.boolean "email_reminders", null: false
    t.boolean "sms_reminders", null: false
    t.boolean "subscribed", null: false
    t.string "remember_token"
    t.string "avatar"
    t.string "google_refresh_token"
    t.string "migration_token"
    t.boolean "is_social_profiles_hidden", default: false, null: false
    t.boolean "fresh", default: true, null: false
    t.index ["email_reminders"], name: "index_users_on_email_reminders"
    t.index ["name"], name: "index_users_on_name"
    t.index ["sms_reminders"], name: "index_users_on_sms_reminders"
    t.index ["subscribed"], name: "index_users_on_subscribed"
  end

  add_foreign_key "events", "places"
  add_foreign_key "events_attendees", "events"
  add_foreign_key "events_attendees", "users"
end
