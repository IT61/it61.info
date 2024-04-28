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

ActiveRecord::Schema.define(version: 2024_04_28_141530) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
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
    t.string "broadcast_url"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
    t.index ["place_id"], name: "index_events_on_place_id"
  end

  create_table "events_attendees", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_events_attendees_on_event_id"
    t.index ["user_id", "event_id"], name: "index_events_attendees_on_user_id_and_event_id", unique: true
    t.index ["user_id"], name: "index_events_attendees_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
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

  create_table "places", force: :cascade do |t|
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

  create_table "social_accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.index ["user_id"], name: "index_social_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
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
