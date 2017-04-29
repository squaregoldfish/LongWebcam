require 'xml'
require 'date'
require 'base64'
require 'rmagick'

class UploadController < ApplicationController
    # This controller does not use user security, so there's no session
    skip_before_filter :verify_authenticity_token

    # Status codes for various processing responses
    # These will be used to look up the appropriate
    # response in the database
    #
    OK_CODE = 200
    NO_CAMERA_CODE = 404
    BAD_SECURITY_CODE = 403
    IMAGE_EXISTS_CODE = 409
    BAD_IMAGE_CODE = 400
    NO_SPACE_CODE = 507
    UNKNOWN_ERROR_CODE = 500

    def upload

        response_code = :ok
        upload_xml = nil
        camera_record = nil
        image_date = nil
        image_datetime = nil
        image_record = nil
        image_data = nil
        weather_data = nil

        # Only POSTs are allowed
        if !request.post?
            response_code = :forbidden
        end

        # Make sure the required parameter has been provided
        if response_code == :ok
            if !params.key?(:image_details)
                response_code = :bad_request
            end
        end

        if response_code == :ok
            # Read in the XML and validate it against the schema
            upload_data = params.fetch(:image_details)
            upload_xml = LibXML::XML::Parser.string(upload_data).parse

            #logger.debug upload_xml

            schema = LibXML::XML::Schema.new("#{Rails.root}/lib/assets/xml/image_upload.xsd")

            schema_valid = true
            begin
                validation_result = upload_xml.validate_schema(schema)
            rescue
                schema_valid = false
            end

#            if !schema_valid
#                logger.error "Upload XML invalid"
#                response_code = :bad_request
#            end
        end

        # At this point, we know the request itself is valid (at the HTTP level at least).
        # Now we pull apart the actual XML and process it.
        result_code = OK_CODE

        # Set up the namespace info
        ns_string = "x:http://www.longwebcam.org/xml/upload"

        # Find the camera record
        camera_id = upload_xml.find_first('//x:image_upload/x:camera/x:id', ns_string).content

        begin
            camera_record = Camera.find(camera_id)
        rescue
            result_code = NO_CAMERA_CODE
        end


        # Check the upload code is correct
        if result_code == OK_CODE
            upload_code = upload_xml.find_first('//x:image_upload/x:camera/x:code', ns_string).content
            if upload_code != camera_record.upload_code
                result_code = BAD_SECURITY_CODE
            end
        end

        # Retrieve the camera details for timezone info etc.
        if result_code == OK_CODE
             camera_details = CameraDetails.find_by_camera_id(camera_id)
             if camera_details.nil?
                Message.createMessage(camera_record.id, MessageType.getIdFromCode("MissingCameraDetails"),
                                      false, "Camera ID: #{camera_id}; while storing uploaded image", image_data)

                result_code = UNKNOWN_ERROR_CODE
             end
        end


        # See if an image already exists for this date
        # If it does, retrieve it. Otherwise create a new one
        if result_code == OK_CODE


            image_date_string = upload_xml.find_first('//x:image_upload/x:image/x:date', ns_string).content
            image_date = Date.parse(image_date_string)
            image_datetime = DateTime.parse(image_date_string)

            image_record = Image::getImageRecord(camera_id, image_date)
            if image_record.nil?
                image_record = Image.new
                image_record.camera_id = camera_id
                image_record.date = image_date
                image_record.image_present = false
            end

            # Extract the image data from the XML (if it exists), and parse it.
            #
            image_data_element = upload_xml.find_first('//x:image_upload/x:image/x:file_data', ns_string)
            if !image_data_element.nil?

                # See if there's already an image stored
                #
                if image_record.image_present?
                    result_code = IMAGE_EXISTS_CODE
                else
                    begin

                        # Decode the image
                        #
                        image_data_unbase64 = Base64.decode64(image_data_element.content)
                        image_data = Magick::Image.from_blob(image_data_unbase64)[0]

                        # Make sure the format is PNG - the conversion happens
                        # at write time
                        image_data.format = 'PNG'

                        # Add the image time details to the record
                        #
                        image_record.image_time = image_datetime
                        image_record.image_time_offset= camera_details.utc_offset
                        image_record.image_time_offset= camera_details.utc_offset
                        image_record.image_daylight_saving = camera_details.daylight_saving
                        image_record.image_timezone_id = camera_details.timezone_id

                        image_record.image_present = true
                    rescue => ex
                        logger.error "#{ex.class}: #{ex.message}"
                        logger.error ex.backtrace
                        result_code = BAD_IMAGE_CODE
                    end
                end
            end


            # Extract the weather data from the XML (if it exists), and add it to the image record
            #
            weather_element = upload_xml.find_first('//x:image_upload/x:weather', ns_string)
            if !weather_element.nil?
                weather_time = DateTime.parse(upload_xml.find_first('//x:image_upload/x:weather/x:time', ns_string).content)
                image_record.weather_time = weather_time

                image_record.temperature = upload_xml.find_first('//x:image_upload/x:weather/x:temperature', ns_string).content
                image_record.weather_code = upload_xml.find_first('//x:image_upload/x:weather/x:weather_code', ns_string).content
                image_record.wind_speed = upload_xml.find_first('//x:image_upload/x:weather/x:wind_speed', ns_string).content
                image_record.wind_bearing = upload_xml.find_first('//x:image_upload/x:weather/x:wind_bearing', ns_string).content
                image_record.rain = upload_xml.find_first('//x:image_upload/x:weather/x:rain', ns_string).content
                image_record.humidity = upload_xml.find_first('//x:image_upload/x:weather/x:humidity', ns_string).content
                image_record.visibility = upload_xml.find_first('//x:image_upload/x:weather/x:visibility', ns_string).content
                image_record.pressure = upload_xml.find_first('//x:image_upload/x:weather/x:pressure', ns_string).content
                image_record.cloud_cover = upload_xml.find_first('//x:image_upload/x:weather/x:cloud_cover', ns_string).content

                image_record.air_quality = upload_xml.find_first('//x:image_upload/x:weather/x:air_quality', ns_string).content
                if image_record.air_quality == -1
                    image_record.air_quality = nil
                end


                image_record.weather_time_offset= camera_details.utc_offset
                image_record.weather_daylight_saving = camera_details.daylight_saving
                image_record.weather_timezone_id = camera_details.timezone_id
            end
        end

        # We've extracted everything we need from the XML.
        #
        # Assuming everything is OK, we can store the image and save the record.
        #
        if result_code == OK_CODE

            # If we've got an image, save it to the archive
            #
            if !image_data.nil?

                image_path = Image.getImagePath(camera_record.id, image_date, 'png')

                # If this file exists already, there's something wrong because the
                # database doesn't think it does!
                if File.exist? image_path
                    Message.createMessage(camera_record.id, MessageType.getIdFromCode("ImageFileExistsNoRecord"),
                                          false, "Image date: #{image_date}", image_data)
                    result_code = UNKNOWN_ERROR_CODE
                else

                    # Write the image to disk
                    image_data.write(image_path)
                end
            end
        end

        if result_code == OK_CODE
            # Save the record to the database
            image_record.save
        end

        # This is where we respond to the client.
        # If the HTTP response code isn't OK,
        # we simply return it.
        #
        if response_code != :ok
            head response_code
        else
            # Otherwise we retrieve the response
            # details from the database and render
            # them for the client
            #
            response = UploadResponse.find_by_code(result_code)
            render :xml => response
        end

    end
end
