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

ActiveRecord::Schema.define(version: 20160416192310) do

  create_table "cameras", force: true do |t|
    t.integer  "camera_id",                                null: false
    t.datetime "retrieved",                                null: false
    t.string   "timezone_id",                              null: false
    t.boolean  "daylight_saving",           default: true
    t.integer  "utc_offset",                               null: false
    t.integer  "download_start",            default: 10
    t.integer  "download_end",              default: 14
    t.string   "url",                                      null: false
    t.string   "upload_code",     limit: 4
  end

  create_table "images", force: true do |t|
    t.integer  "camera_id",               null: false
    t.date     "date",                    null: false
    t.datetime "image_time",              null: false
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
    t.binary   "image_data"
  end

end
