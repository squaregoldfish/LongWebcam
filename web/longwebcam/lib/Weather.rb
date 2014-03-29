require 'xml'
require 'Location'

# Class for retrieving weather information
# for a given location.
#
class Weather

    ACCOUNT_NAME = "WorldWeatherOnline"
    OK_RESPONSE = "200"

    # Check the supplied positing and initialise the instance variables
    # The camera id is needed so we can identify any messages generated
    # during a failure.
    #
    def initialize(lon, lat, camera_id)

         # Validate the input parameters
         raise ArgumentError, "Invalid longitude" if !Location.lon_ok?(lon)
         raise ArgumentError, "Invalid latitude" if !Location.lat_ok?(lat)

         # Store the input parameters as instance variables
         @lon = Location.convert_lon_to_negative(lon)
         @lat = lat
         @camera_id = camera_id

         # Initialise other instance variables
         #
         @temperature = nil
         @weather_code = nil
         @wind_speed = nil
         @wind_bearing = nil
         @rain = nil
         @humidity = nil
         @visibility = nil
         @pressure = nil
         @cloud_cover = nil
         @air_quality = nil
         @observation_time = nil
         @observation_lon = nil
         @observation_lat = nil

         @data_retrieved = false
    end

    # Retrieve the current weather conditions from the internet,
    # and store them in the object.
    def retrieve_data

        # Build the HTTP request
        # You will note that we're not verifying the SSL certificate.
        # This is because we're on an outdated version of Ruby,
        # and the workaround is too much hassle. Given that we're talking
        # to Google I don't think it's much of a problem.
        url = build_url
        uri = URI.parse(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)

        # Send the request
        response = http.request(request)

        if response.code != OK_RESPONSE
            Message.createMessage(@camera_id, MessageType.getIdFromCode("WeatherRetrievalFailure"),
                                  false, "URL: #{url}\nResponse Code: #{response.code}", nil)
        else
            response_xml = LibXML::XML::Parser.string(response.body).parse

            # See if the response is an error
            error = response_xml.find_first('/data/error')
            if !error.nil?
                Message.createMessage(@camera_id, MessageType.getIdFromCode("WeatherRetrievalFailure"),
                                      false, "URL: #{url}", response.body)
            else
                # Pull the data out from the XML
                xpath_root = "/data/current_condition/"

                @temperature = response_xml.find_first(xpath_root + "temp_C").content
                @weather_code = response_xml.find_first(xpath_root + "weatherCode").content
                @wind_speed = response_xml.find_first(xpath_root + "windspeedMiles").content
                @wind_bearing = response_xml.find_first(xpath_root + "winddirDegree").content
                @rain = response_xml.find_first(xpath_root + "precipMM").content
                @humidity = response_xml.find_first(xpath_root + "humidity").content
                @visibility = response_xml.find_first(xpath_root + "visibility").content
                @pressure = response_xml.find_first(xpath_root + "pressure").content
                @cloud_cover = response_xml.find_first(xpath_root + "cloudcover").content
                @observation_time = DateTime.parse(response_xml.find_first(xpath_root + "localObsDateTime").content)

                
            end
        end

        @data_retrieved = true
        return @data_retrieved
    end

    # Accessor methods
    #
    def data_retrieved?
        @data_retrieved
    end
    
    def temperature
        @temperature
    end

    def weather_code
        @weather_code
    end

    def wind_speed
        @wind_speed
    end

    def wind_bearing
        @wind_bearing
    end

    def rain
        @rain
    end

    def humidity
        @humidity
    end

    def visibility
        @visibility
    end

    def pressure
        @pressure
    end

    def cloud_cover
        @cloud_cover
    end

    def air_quality
        @air_quality
    end

    def observation_time
        @observation_time
    end

    def observation_lon
        @observation_lon
    end

    def observation_lat
        @observation_lat
    end


    #====================================================
    #
    private

    def build_url()
        account = Account.find_by_account(ACCOUNT_NAME)

        # Base URL
        url = account.url + account.path

        # API Key
        url = url + "?key=#{account.api_key}"

        # Location
        url = url + "&q=#{@lat},#{@lon}"

        # Other API options
        url = url + "&format=xml&extra=localObsTime&num_of_days=1&cc=yes&includelocation=yes"

        return url
    end
end
