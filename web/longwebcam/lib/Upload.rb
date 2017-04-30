require 'xml'
require 'base64'
require 'rmagick'

# Class for handling the upload of images and related weather information.
class Upload

    # CONSTANTS
    ACCOUNT_NAME = "LWCUpload"
    RESPONSE_OK = '200'

    # Constructor - stores passed in info and retrieves additional
    # required details
    #
    def initialize(camera_id, image_date)

        # Store the passed in values in instance variables
        @camera_id = camera_id
        @image_date = image_date
        @image_data = nil
        @weather_data = nil

        # Retrieve the camera's upload code
        #
        camera_record = Camera.find_by_id(camera_id)
        @upload_code = camera_record.upload_code

        @uploadResponseXML = nil
    end

    # Add an image to the data to be uploaded
    def addImage(data)
        begin
            # Make sure we've been given a proper image before adding it
            parsed_image = Magick::Image.from_blob(data)[0]
            @image_data = data
        rescue
            raise ArgumentError, "Passed in data is not an image"
        end
    end

    # Add weather details to the data to be uploaded
    def addWeather(weather)
        if !weather.instance_of?(Weather)
            raise ArgumentError, "Passed in data is not a Weather object"
        else
            @weather_data = weather
        end
    end

    # Upload the image to the LWC Server for storage.
    # Returns the code from the upload - either the code
    # from the XML response to the upload, or the HTTP response code
    # if there's no returned XML.
    #
    def doUpload()
        upload_account = Account.find_by_account(ACCOUNT_NAME)
        req = Net::HTTP.post_form(URI.parse(upload_account.url + upload_account.path), {:image_details => buildXML()})

        response_code = req.code

        if req.code == '200'
            @uploadResponseXML = req.body
            response_code = extractXMLRepsonseCode()
        end

        return response_code
    end

    # Return the full response XML
    def uploadResponseXML
        @uploadResponseXML
    end


    ##############################################
    private

    # Build the upload XML document for this upload instance
    #
    def buildXML()
        xml = ::Builder::XmlMarkup.new(:target => upload_xml = "")
        upload_doc = xml.image_upload(:xmlns => "http://www.longwebcam.org/xml/upload",
                                      :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                      :"xsi:schemaLocation" => "http://www.longwebcam.org/xml/upload") {
        xml.camera { |b| b.id(@camera_id); b.code(@upload_code) }
        xml.image { |b| b.date(@image_date); b.file_data(Base64.encode64(@image_data)) }

        if !@weather_data.nil?
            xml.weather { |b| b.time(@weather_data.observation_time);
                          b.temperature(@weather_data.temperature);
                          b.weather_code(@weather_data.weather_code);
                          b.wind_speed(@weather_data.wind_speed);
                          b.wind_bearing(@weather_data.wind_bearing);
                          b.rain(@weather_data.rain);
                          b.humidity(@weather_data.humidity);
                          b.visibility(@weather_data.visibility);
                          b.pressure(@weather_data.pressure);
                          b.cloud_cover(@weather_data.cloud_cover);
                          b.air_quality(@weather_data.air_quality);
            }
        end
        }

        return upload_xml
    end

    # Extract the response code from the XML returned by the upload request
    #
    def extractXMLRepsonseCode()
        code = nil

        puts @uploadResponseXML

        if !@uploadResponseXML.nil?
            parsed_xml = LibXML::XML::Parser.string(@uploadResponseXML).parse
            schema = LibXML::XML::Schema.new("#{Rails.root}/public/xml/upload_response.xsd")

            begin
                validation_result = parsed_xml.validate_schema(schema)

                ns_string = "x:http://www.longwebcam.org/xml/upload_response"
                code = parsed_xml.find_first('//x:upload_response/x:code', ns_string).content
            rescue
                raise IOError, "Upload Repsonse XML is not valid"
            end
        end

        return code
    end
end
