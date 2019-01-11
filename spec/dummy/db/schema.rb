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

ActiveRecord::Schema.define(version: 20161021201011) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.datetime "event_date_time"
    t.integer  "user_id"
    t.string   "type",            limit: 255
    t.string   "pid",             limit: 255
    t.string   "software",        limit: 255
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary",         limit: 255
    t.string   "outcome",         limit: 255
    t.text     "detail"
    t.text     "exception"
    t.string   "user_key",        limit: 255
    t.string   "permanent_id",    limit: 255
  end

  add_index "events", ["event_date_time"], name: "index_events_on_event_date_time", using: :btree
  add_index "events", ["outcome"], name: "index_events_on_outcome", using: :btree
  add_index "events", ["permanent_id"], name: "index_events_on_permanent_id", using: :btree
  add_index "events", ["pid"], name: "index_events_on_pid", using: :btree
  add_index "events", ["type"], name: "index_events_on_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255, default: "", null: false
    t.string   "first_name",             limit: 255
    t.string   "middle_name",            limit: 255
    t.string   "nickname",               limit: 255
    t.string   "last_name",              limit: 255
    t.string   "display_name",           limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
