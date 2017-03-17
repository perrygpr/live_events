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

ActiveRecord::Schema.define(version: 20140910225324) do

  create_table "analytics_events", force: true do |t|
    t.string   "device_id",           limit: 32, null: false
    t.string   "type",                           null: false
    t.datetime "timestamp",                      null: false
    t.string   "event_id",            limit: 32
    t.string   "player_id",           limit: 50
    t.string   "score_name"
    t.integer  "score_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_id",              limit: 32, null: false
    t.string   "award_id",            limit: 32
    t.string   "device_token_id",     limit: 32
    t.string   "remote_ip"
    t.string   "suspicious_activity"
  end

  add_index "analytics_events", ["device_id"], name: "index_analytics_events_on_device_id", using: :btree
  add_index "analytics_events", ["event_id"], name: "index_analytics_events_on_event_id", using: :btree
  add_index "analytics_events", ["player_id", "event_id"], name: "index_analytics_events_on_player_id_and_event_id", using: :btree
  add_index "analytics_events", ["type"], name: "index_analytics_events_on_type", using: :btree

  create_table "apps", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secret_key", limit: 32, null: false
  end

  add_index "apps", ["name"], name: "index_apps_on_name_and_platform", unique: true, using: :btree

  create_table "awards", force: true do |t|
    t.string   "player_id",  limit: 50, null: false
    t.string   "device_id",  limit: 32, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",       limit: 32, null: false
    t.string   "definition", limit: 32, null: false
    t.string   "app_id",     limit: 32, null: false
    t.string   "milestone"
    t.string   "reward"
  end

  add_index "awards", ["app_id", "player_id"], name: "index_awards_on_app_id_and_player_id", using: :btree
  add_index "awards", ["type", "definition"], name: "index_awards_on_type_and_definition", unique: true, using: :btree

  create_table "cheaters", force: true do |t|
    t.string   "player_id",  limit: 50, null: false
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_tokens", force: true do |t|
    t.string   "device_id",         limit: 32,                 null: false
    t.string   "install_record_id", limit: 32,                 null: false
    t.string   "token",             limit: 20,                 null: false
    t.boolean  "used",                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "device_tokens", ["device_id", "install_record_id"], name: "index_device_tokens_on_device_id_and_install_record_id", unique: true, using: :btree
  add_index "device_tokens", ["token"], name: "index_device_tokens_on_token", unique: true, using: :btree

  create_table "devices", force: true do |t|
    t.string   "advertising_id"
    t.string   "android_id"
    t.string   "vendor_id"
    t.string   "country",        limit: 10
    t.string   "language_code",  limit: 10
    t.string   "os",             limit: 10
    t.string   "os_version",     limit: 25
    t.string   "device_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "devices", ["advertising_id"], name: "index_devices_on_advertising_id", unique: true, using: :btree
  add_index "devices", ["android_id"], name: "index_devices_on_android_id", unique: true, using: :btree
  add_index "devices", ["vendor_id"], name: "index_devices_on_vendor_id", unique: true, using: :btree

  create_table "events", force: true do |t|
    t.string   "app_id",                   limit: 32,                 null: false
    t.string   "name",                                                null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "min_app_version"
    t.string   "min_asset_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "platform_ios",                        default: false
    t.boolean  "platform_google",                     default: false
    t.boolean  "platform_amazon",                     default: false
    t.string   "notification_content_uid"
    t.integer  "performance_throttle",                default: 100
    t.string   "restrictions"
    t.text     "countries"
    t.boolean  "audited",                             default: false
    t.string   "milestones"
    t.string   "rewards"
    t.string   "eligiblesession"
    t.string   "eligiblelevel"
    t.time     "reappear"
    t.time     "durationactive"
  end

  create_table "install_records", force: true do |t|
    t.string   "device_id",         limit: 32, null: false
    t.string   "app_id",            limit: 32, null: false
    t.string   "install_id",        limit: 32, null: false
    t.datetime "install_timestamp"
    t.datetime "last_timestamp"
    t.string   "install_version"
    t.string   "last_version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "install_records", ["device_id", "app_id"], name: "index_install_records_on_device_id_and_app_id", using: :btree
  add_index "install_records", ["install_id", "app_id"], name: "index_install_records_on_install_id_and_app_id", unique: true, using: :btree

  create_table "milestone_awards", force: true do |t|
    t.string   "event_id",    limit: 32, null: false
    t.string   "name",                   null: false
    t.string   "score_name",             null: false
    t.integer  "score_value",            null: false
    t.string   "item",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "milestone_awards", ["event_id", "name"], name: "index_milestone_awards_on_event_id_and_name", unique: true, using: :btree
  add_index "milestone_awards", ["event_id"], name: "index_milestone_awards_on_event_id", using: :btree

  create_table "pfids", force: true do |t|
    t.string   "last_locale"
    t.string   "displayname"
    t.string   "hashed_password"
    t.string   "email"
    t.datetime "last_connection"
    t.string   "last_guid"
    t.datetime "last_device_reset"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rank_awards", force: true do |t|
    t.string   "event_id",   limit: 32, null: false
    t.integer  "start_rank",            null: false
    t.integer  "end_rank",              null: false
    t.string   "item",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "rank_awards", ["event_id", "end_rank"], name: "index_rank_awards_on_event_id_and_end_rank", unique: true, using: :btree
  add_index "rank_awards", ["event_id", "name"], name: "index_rank_awards_on_event_id_and_name", unique: true, using: :btree
  add_index "rank_awards", ["event_id", "start_rank"], name: "index_rank_awards_on_event_id_and_start_rank", unique: true, using: :btree
  add_index "rank_awards", ["event_id"], name: "index_rank_awards_on_event_id", using: :btree

  create_table "scores", force: true do |t|
    t.string   "event_id",            limit: 32, null: false
    t.string   "player_id",           limit: 50, null: false
    t.string   "name",                           null: false
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "timestamp",                      null: false
    t.string   "milestones_attained"
  end

  add_index "scores", ["event_id", "name"], name: "index_scores_on_event_id_and_name", using: :btree
  add_index "scores", ["player_id", "event_id", "name"], name: "index_scores_on_player_id_and_event_id_and_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",               default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                             null: false
    t.string   "uid",                              null: false
    t.string   "provider",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree

end
