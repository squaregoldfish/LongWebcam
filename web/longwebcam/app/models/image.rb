class Image < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
    has_many :weather_codes, :foreign_key => "code"

    # A utility method for getting the path to an image file
    # identified by Camera ID and date.
    #
    # Automatically creates the directory if it doesn't exist
    def Image.getImagePath(id, date, suffix)
        # The root path is stored in the database
        root = Account.find_by_account('ImageStore').path

        image_dir = "#{root}/#{id}"
        if !File.exists? image_dir
            Dir.mkdir image_dir
        end


        path = "#{root}/#{id}/#{date}.#{suffix}"

        path
    end

    # Locate the image record for a given camera and date
    #
    def Image.getImageRecord(camera_id, date)
        record = nil

        records = find(:all, :conditions => ['camera_id LIKE ? AND date LIKE ?', camera_id, date])

        if records.size > 0
            record = records.first
        end

        return record
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
    end
end
