require 'rmagick'

class Images < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
    has_many :weather_codes, :foreign_key => "code"

    RESPONSE_OK = "200"

    def Images.createImageRecord(cam_id, image)

        camera_utc_offset = Camera.find(cam_id).utc_offset

        new_image = Images.new
        new_image.camera_id = cam_id
        new_image.date = DateTime.now
        new_image.image_time = Time.now.utc + camera_utc_offset
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

    # Determines whether or not this image already has a counterpart
    # on the main server
    def exists_on_server()

        result = 1

        url = GRUNT_CONFIG["main_url"] + "/grunt/image_exists"
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        if url.start_with?('https')
            # You will note that we're not verifying the SSL certificate.
            #  This is because we're on an outdated version of Ruby,
            # and the workaround is too much hassle.
            #
            # Given that we're only grabbing images, this shouldn't really be a problem.
            #
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data({"api_key" => GRUNT_CONFIG["grunt_api_key"], "camera_id" => self.camera_id, "date" => self.date})

        response = http.request(request)

        if response.nil?
            logger.fatal("Empty response from server")
            result = -1
        elsif response.code != RESPONSE_OK
            logger.error("Non-OK response from server: " + response.code)
            result = -1
        else
            if response.body == "true"
                result = 1
            else
                result = 0
            end
        end

        return result
    end

    def get_weather

        # Get lon/lat from camera record...
        camera = Camera.find(self.camera_id)

        weather = nil

        unless self.weather_time.nil?

            weather = Weather.new(camera.longitude, camera.latitude, self.camera_id)
            weather.set_temperature(self.temperature)
            weather.set_weather_code(self.weather_code)
            weather.set_wind_speed(self.wind_speed)
            weather.set_wind_bearing(self.wind_bearing)
            weather.set_rain(self.rain)
            weather.set_humidity(self.humidity)
            weather.set_visibility(self.visibility)
            weather.set_pressure(self.pressure)
            weather.set_cloud_cover(self.cloud_cover)
            weather.set_air_quality(self.air_quality)
            weather.set_observation_time(self.weather_time)

            weather.set_data_retrieved(true)
        end

        return weather
    end

    def to_s
        return "Camera #{self.camera_id}, Date #{self.date}"
    end
end
