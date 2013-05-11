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

ActiveRecord::Schema.define(:version => 20130511205331) do

  create_table "camera_details", :force => true do |t|
    t.integer  "camera_id"
    t.date     "details_date"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "bearing"
    t.integer  "ground_height"
    t.integer  "camera_height"
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "resolution_x"
    t.integer  "resolution_y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "camera_tags", :force => true do |t|
    t.string   "tag"
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cameras", :force => true do |t|
    t.integer  "owner"
    t.integer  "type",          :limit => 1
    t.string   "url"
    t.string   "serial_number"
    t.integer  "schedule"
    t.integer  "test_camera",   :limit => 1
    t.string   "licence"
    t.string   "upload_code",   :limit => 4
    t.integer  "watermark",     :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cameras_events", :id => false, :force => true do |t|
    t.integer  "camera_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cameras_tags", :id => false, :force => true do |t|
    t.integer  "camera_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_tags", :force => true do |t|
    t.string   "tag"
    t.integer  "parent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "name"
    t.text     "description"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_tags", :id => false, :force => true do |t|
    t.integer  "event_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_urls", :id => false, :force => true do |t|
    t.integer  "event_id"
    t.integer  "url_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :id => false, :force => true do |t|
    t.integer  "camera_id"
    t.date     "date"
    t.integer  "image_present",              :limit => 1
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
  end

  create_table "message_types", :force => true do |t|
    t.string   "subject"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "camera_id"
    t.datetime "timestamp"
    t.integer  "message_type",  :limit => 1
    t.integer  "read_by_user",  :limit => 1
    t.integer  "read_by_admin", :limit => 1
    t.integer  "resolved",      :limit => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "city"
    t.string   "county"
    t.string   "country"
    t.string   "postcode"
    t.integer  "privileges"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weather_codes", :id => false, :force => true do |t|
    t.integer  "code"
    t.string   "condition"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
