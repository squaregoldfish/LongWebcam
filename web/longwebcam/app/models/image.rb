class Image < ActiveRecord::Base
    attr_accessible :camera_id, :date, :image_present, :image_time, :image_time_offeet_hour, :image_time_offset_minute, :weather_time, :weather_time_offset_hour, :weather_time_offset_minute, :temperature, :weather_type, :wind_speed, :wind_bearing, :rain, :visibility, :pressure, :cloud_cover, :air_quality
end
