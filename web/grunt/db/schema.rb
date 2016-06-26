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

ActiveRecord::Schema.define(version: 20160626143732) do

  create_table "cameras", primary_key: "camera_id", force: true do |t|
    t.datetime "retrieved",                                null: false
    t.string   "timezone_id",                              null: false
    t.boolean  "daylight_saving",           default: true
    t.integer  "utc_offset",                               null: false
    t.integer  "download_start",            default: 10
    t.integer  "download_end",              default: 14
    t.string   "url",                                      null: false
    t.string   "upload_code",     limit: 4
    t.float    "longitude",                                null: false
    t.float    "latitude",                                 null: false
  end

  create_table "images", force: true do |t|
    t.integer  "camera_id",                                null: false
    t.date     "date",                                     null: false
    t.datetime "image_time",                               null: false
    t.datetime "weather_time"
    t.integer  "temperature"
    t.integer  "weather_code"
    t.integer  "wind_speed"
    t.integer  "wind_bearing"
    t.float    "rain"
    t.float    "visibility"
    t.integer  "pressure"
    t.integer  "cloud_cover"
    t.integer  "air_quality"
    t.string   "image_timezone_id"
    t.string   "weather_timezone_id"
    t.boolean  "image_daylight_saving"
    t.boolean  "weather_daylight_saving"
    t.integer  "image_time_offset"
    t.integer  "weather_time_offset"
    t.integer  "humidity"
    t.binary   "image_data",              limit: 16777215
  end

  create_table "message_types", force: true do |t|
    t.string   "subject",    null: false
    t.text     "text",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       null: false
  end

  add_index "message_types", ["code"], name: "message_types_code_idx", unique: true, using: :btree

  create_table "messages", force: true do |t|
    t.integer  "camera_id",                                     null: false
    t.datetime "timestamp",                                     null: false
    t.integer  "message_type",                                  null: false
    t.boolean  "read",                          default: false, null: false
    t.boolean  "resolved",                      default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "extra_text",   limit: 16777215
    t.binary   "extra_data",   limit: 16777215
  end

  add_index "messages", ["camera_id"], name: "messages_cameraid_idx", using: :btree
  add_index "messages", ["message_type"], name: "messages_messagetype_idx", using: :btree
  add_index "messages", ["read"], name: "messages_read_idx", using: :btree

end
