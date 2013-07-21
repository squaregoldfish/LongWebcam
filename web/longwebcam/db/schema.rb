# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130721175327) do

  create_table "accounts", :force => true do |t|
    t.string "account",  :null => false
    t.string "username"
    t.string "password"
    t.string "api_key"
    t.string "url"
    t.string "path"
  end

  add_index "accounts", ["account"], :name => "accounts_account_idx", :unique => true

  create_table "camera_details", :force => true do |t|
    t.integer  "camera_id"
    t.date     "details_date",      :null => false
    t.float    "longitude",         :null => false
    t.float    "latitude",          :null => false
    t.integer  "bearing",           :null => false
    t.integer  "ground_height"
    t.integer  "camera_height"
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "resolution_x",      :null => false
    t.integer  "resolution_y",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "utc_offset_hour"
    t.integer  "utc_offset_minute"
    t.string   "timezone_id"
  end

  add_index "camera_details", ["details_date"], :name => "cameradetails_detailsdate_idx"
  add_index "camera_details", ["latitude"], :name => "cameradetails_latitude_idx"
  add_index "camera_details", ["longitude"], :name => "cameradetails_longitude_idx"
  add_index "camera_details", ["timezone_id"], :name => "camera_details_timzoneid_idx"

  create_table "camera_tags", :force => true do |t|
    t.string   "tag",        :null => false
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "camera_tags", ["parent"], :name => "cameratags_parent_idx"
  add_index "camera_tags", ["tag"], :name => "cameratags_tag_idx"

  create_table "cameras", :force => true do |t|
    t.integer  "owner",                      :null => false
    t.integer  "camera_type",                :null => false
    t.string   "url"
    t.string   "serial_number"
    t.integer  "schedule"
    t.boolean  "test_camera"
    t.string   "licence"
    t.string   "upload_code",   :limit => 4
    t.boolean  "watermark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cameras_events", :id => false, :force => true do |t|
    t.integer  "camera_id",  :null => false
    t.integer  "event_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cameras_events", ["camera_id", "event_id"], :name => "camerasevents_ids_idx", :unique => true

  create_table "cameras_tags", :id => false, :force => true do |t|
    t.integer  "camera_id",  :null => false
    t.integer  "tag_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cameras_tags", ["camera_id", "tag_id"], :name => "camerastags_ids_idx", :unique => true

  create_table "event_tags", :force => true do |t|
    t.string   "tag",        :null => false
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_tags", ["tag"], :name => "eventtags_parent_idx"
  add_index "event_tags", ["tag"], :name => "eventtags_tag_idx"

  create_table "event_urls", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "accessible",       :limit => 1
    t.date     "last_check_date"
    t.date     "last_access_date"
    t.string   "archive_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",               :null => false
    t.text     "description",        :null => false
    t.date     "start_date",         :null => false
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description_source"
  end

  add_index "events", ["end_date"], :name => "events_enddate_idx"
  add_index "events", ["start_date"], :name => "events_startdate_idx"

  create_table "events_tags", :id => false, :force => true do |t|
    t.integer  "event_id",   :null => false
    t.integer  "tag_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events_tags", ["event_id", "tag_id"], :name => "eventstags_ids_idx", :unique => true

  create_table "events_urls", :id => false, :force => true do |t|
    t.integer  "event_id"
    t.integer  "url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.integer  "camera_id",                  :null => false
    t.date     "date",                       :null => false
    t.boolean  "image_present",              :null => false
    t.time     "image_time"
    t.integer  "image_time_offeet_hour"
    t.integer  "image_time_offset_minute"
    t.time     "weather_time"
    t.integer  "weather_time_offset_hour"
    t.integer  "weather_time_offset_minute"
    t.integer  "temperature"
    t.integer  "weather_type"
    t.integer  "wind_speed"
    t.integer  "wind_bearing"
    t.float    "rain"
    t.float    "visibility"
    t.integer  "pressure"
    t.integer  "cloud_cover"
    t.integer  "air_quality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_timezone_id"
    t.string   "weather_timezine_id"
  end

  add_index "images", ["camera_id", "date"], :name => "image_camid-date_idx", :unique => true
  add_index "images", ["date"], :name => "image_date_idx"
  add_index "images", ["image_present"], :name => "image_imagepresent_idx"

  create_table "message_types", :force => true do |t|
    t.string   "subject",    :null => false
    t.text     "text",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",       :null => false
  end

  add_index "message_types", ["code"], :name => "message_types_code_idx", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "camera_id",                             :null => false
    t.datetime "timestamp",                             :null => false
    t.integer  "message_type",                          :null => false
    t.boolean  "read_by_user",       :default => false, :null => false
    t.boolean  "read_by_admin",      :default => false, :null => false
    t.boolean  "resolved",           :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "despatched_to_user", :default => false, :null => false
    t.boolean  "can_despatch",       :default => false
    t.string   "extra_text"
    t.binary   "extra_data"
  end

  add_index "messages", ["camera_id"], :name => "messages_cameraid_idx"
  add_index "messages", ["message_type"], :name => "messages_messagetype_idx"
  add_index "messages", ["read_by_admin"], :name => "messages_readbyadmin_idx"
  add_index "messages", ["read_by_user"], :name => "messages_readbyuser_idx"

  create_table "upload_responses", :force => true do |t|
    t.integer "code",    :null => false
    t.string  "message", :null => false
  end

  add_index "upload_responses", ["code"], :name => "uploadresponses_code_idx", :unique => true

  create_table "users", :force => true do |t|
    t.string   "username",                       :null => false
    t.string   "password_digest"
    t.string   "email",                          :null => false
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "postcode"
    t.integer  "privileges",      :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_salt",                  :null => false
  end

  add_index "users", ["email"], :name => "users_email_idx", :unique => true
  add_index "users", ["username"], :name => "users_username_idx", :unique => true

  create_table "weather_codes", :id => false, :force => true do |t|
    t.integer  "code"
    t.string   "condition",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
