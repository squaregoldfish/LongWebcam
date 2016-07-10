class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
        t.integer  :camera_id, {:null => false}
        t.date     :date, {:null => false}
        t.datetime :image_time, {:null => false}
        t.datetime :weather_time
        t.integer  :temperature
        t.integer  :weather_code
        t.integer  :wind_speed
        t.integer  :wind_bearing
        t.float    :rain
        t.float    :visibility
        t.integer  :pressure
        t.integer  :cloud_cover
        t.integer  :air_quality
        t.string   :image_timezone_id
        t.string   :weather_timezone_id
        t.boolean  :image_daylight_saving
        t.boolean  :weather_daylight_saving
        t.integer  :image_time_offset
        t.integer  :weather_time_offset
        t.integer  :humidity
        t.binary   :image_data
    end
  end
end
