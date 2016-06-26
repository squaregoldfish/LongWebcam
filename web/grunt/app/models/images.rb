require 'RMagick'

class Images < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
    has_many :weather_codes, :foreign_key => "code"

    def Images.createImageRecord(cam_id, image)
        new_image = Images.new
        new_image.camera_id = cam_id
        new_image.date = DateTime.now
        new_image.image_time = DateTime.now
        new_image.image_data = image.to_blob()

        new_image.save

        return new_image
    end


    # Add a set of weather data to this record
    # Note that this does not save the record
    #
    def add_weather(weather)
        self.weather_time = weather.observation_time
        self.temperature = weather.temperature
        self.weather_code = weather.weather_code
        self.wind_speed = weather.wind_speed
        self.wind_bearing = weather.wind_bearing
        self.rain = weather.rain
        self.visibility = weather.visibility
        self.pressure = weather.pressure
        self.cloud_cover = weather.cloud_cover
        self.air_quality = weather.air_quality

        self.save
    end
end
