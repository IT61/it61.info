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

ActiveRecord::Schema.define(version: 20140710234722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.integer   "user_id",                  null: false
    t.string    "provider",                 null: false
    t.string    "uid",                      null: false
    t.timestamp "created_at", precision: 6
    t.timestamp "updated_at", precision: 6
    t.string    "link"
  end

  create_table "event_participations", force: true do |t|
    t.integer   "user_id"
    t.integer   "event_id"
    t.timestamp "created_at", precision: 6
    t.timestamp "updated_at", precision: 6
    t.datetime  "deleted_at"
  end

  add_index "event_participations", ["deleted_at"], name: "index_event_participations_on_deleted_at", using: :btree
  add_index "event_participations", ["event_id"], name: "index_event_participations_on_event_id", using: :btree
  add_index "event_participations", ["user_id"], name: "index_event_participations_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string    "title",                                      null: false
    t.timestamp "created_at",   precision: 6
    t.timestamp "updated_at",   precision: 6
    t.integer   "organizer_id"
    t.boolean   "published",                  default: false
    t.text      "description"
    t.timestamp "started_at",   precision: 6
    t.string    "title_image"
    t.string    "place"
    t.datetime  "deleted_at"
  end

  add_index "events", ["deleted_at"], name: "index_events_on_deleted_at", using: :btree
  add_index "events", ["organizer_id"], name: "index_events_on_organizer_id", using: :btree

  create_table "users", force: true do |t|
    t.string    "email"
    t.string    "crypted_password"
    t.string    "salt"
    t.timestamp "created_at",                      precision: 6
    t.timestamp "updated_at",                      precision: 6
    t.string    "remember_me_token"
    t.timestamp "remember_me_token_expires_at",    precision: 6
    t.string    "reset_password_token"
    t.timestamp "reset_password_token_expires_at", precision: 6
    t.timestamp "reset_password_email_sent_at",    precision: 6
    t.timestamp "last_login_at",                   precision: 6
    t.timestamp "last_logout_at",                  precision: 6
    t.timestamp "last_activity_at",                precision: 6
    t.string    "last_login_from_ip_address"
    t.string    "name"
    t.integer   "role"
    t.string    "first_name"
    t.string    "last_name"
    t.text      "bio"
    t.string    "avatar_image"
    t.datetime  "deleted_at"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
