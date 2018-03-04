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

ActiveRecord::Schema.define(version: 20180304161534) do

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "account",  null: false
    t.string "username"
    t.string "password"
    t.string "api_key"
    t.string "url"
    t.string "path"
    t.index ["account"], name: "accounts_account_idx", unique: true, using: :btree
  end

  create_table "camera_details", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "camera_id"
    t.date     "details_date",                            null: false
    t.float    "longitude",       limit: 24,              null: false
    t.float    "latitude",        limit: 24,              null: false
    t.integer  "bearing",                                 null: false
    t.integer  "ground_height"
    t.integer  "camera_height"
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "resolution_x",                            null: false
    t.integer  "resolution_y",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone_id"
    t.boolean  "daylight_saving",                         null: false
    t.integer  "utc_offset"
    t.integer  "download_start",             default: 10
    t.integer  "download_end",               default: 14
    t.index ["details_date"], name: "cameradetails_detailsdate_idx", using: :btree
    t.index ["latitude"], name: "cameradetails_latitude_idx", using: :btree
    t.index ["longitude"], name: "cameradetails_longitude_idx", using: :btree
    t.index ["timezone_id"], name: "camera_details_timzoneid_idx", using: :btree
  end

  create_table "camera_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "tag",        null: false
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent"], name: "cameratags_parent_idx", using: :btree
    t.index ["tag"], name: "cameratags_tag_idx", using: :btree
  end

  create_table "cameras", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "owner",                                       null: false
    t.integer  "camera_type",                                 null: false
    t.string   "url"
    t.string   "serial_number"
    t.boolean  "test_camera"
    t.string   "licence"
    t.string   "upload_code",   limit: 4
    t.boolean  "watermark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",         limit: 100
    t.text     "description",   limit: 65535
    t.boolean  "disabled",                    default: false
  end

  create_table "cameras_events", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "camera_id",  null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["camera_id", "event_id"], name: "camerasevents_ids_idx", unique: true, using: :btree
  end

  create_table "cameras_tags", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "camera_id",  null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["camera_id", "tag_id"], name: "camerastags_ids_idx", unique: true, using: :btree
  end

  create_table "event_tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "tag",        null: false
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["tag"], name: "eventtags_parent_idx", using: :btree
    t.index ["tag"], name: "eventtags_tag_idx", using: :btree
  end

  create_table "event_urls", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "accessible",       limit: 1
    t.date     "last_check_date"
    t.date     "last_access_date"
    t.string   "archive_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name",                             null: false
    t.text     "description",        limit: 65535, null: false
    t.date     "start_date",                       null: false
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description_source"
    t.index ["end_date"], name: "events_enddate_idx", using: :btree
    t.index ["start_date"], name: "events_startdate_idx", using: :btree
  end

  create_table "events_tags", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "event_id",   null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["event_id", "tag_id"], name: "eventstags_ids_idx", unique: true, using: :btree
  end

  create_table "events_urls", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "event_id"
    t.integer  "url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "camera_id",                          null: false
    t.date     "date",                               null: false
    t.boolean  "image_present",                      null: false
    t.datetime "image_time"
    t.datetime "weather_time"
    t.integer  "temperature"
    t.integer  "weather_code"
    t.integer  "wind_speed"
    t.integer  "wind_bearing"
    t.float    "rain",                    limit: 24
    t.float    "visibility",              limit: 24
    t.integer  "pressure"
    t.integer  "cloud_cover"
    t.integer  "air_quality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_timezone_id"
    t.string   "weather_timezone_id"
    t.boolean  "image_daylight_saving"
    t.boolean  "weather_daylight_saving"
    t.integer  "image_time_offset"
    t.integer  "weather_time_offset"
    t.integer  "humidity"
    t.index ["camera_id", "date"], name: "image_camid-date_idx", unique: true, using: :btree
    t.index ["date"], name: "image_date_idx", using: :btree
    t.index ["image_present"], name: "image_imagepresent_idx", using: :btree
  end

  create_table "message_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "subject",                  null: false
    t.text     "text",       limit: 65535, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",                     null: false
    t.index ["code"], name: "message_types_code_idx", unique: true, using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "camera_id",                                           null: false
    t.datetime "timestamp",                                           null: false
    t.integer  "message_type",                                        null: false
    t.boolean  "read_by_user",                        default: false, null: false
    t.boolean  "read_by_admin",                       default: false, null: false
    t.boolean  "resolved",                            default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "despatched_to_user",                  default: false, null: false
    t.boolean  "can_despatch",                        default: false
    t.text     "extra_text",         limit: 16777215
    t.binary   "extra_data",         limit: 16777215
    t.index ["camera_id"], name: "messages_cameraid_idx", using: :btree
    t.index ["message_type"], name: "messages_messagetype_idx", using: :btree
    t.index ["read_by_admin"], name: "messages_readbyadmin_idx", using: :btree
    t.index ["read_by_user"], name: "messages_readbyuser_idx", using: :btree
  end

  create_table "sessions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "session_id",               null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "upload_responses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer "code",    null: false
    t.string  "message", null: false
    t.index ["code"], name: "uploadresponses_code_idx", unique: true, using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "username",                    null: false
    t.string   "password_digest"
    t.string   "email",                       null: false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "postcode"
    t.integer  "privileges",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt",               null: false
    t.index ["email"], name: "users_email_idx", unique: true, using: :btree
    t.index ["username"], name: "users_username_idx", unique: true, using: :btree
  end

  create_table "weather_codes", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "code"
    t.string   "condition",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
