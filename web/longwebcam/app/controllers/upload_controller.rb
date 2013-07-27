require 'xml'
require 'date'
require 'base64'
require 'RMagick'

class UploadController < ApplicationController

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
            schema = LibXML::XML::Schema.new("#{RAILS_ROOT}/resources/xml/image_upload.xsd")

            schema_valid = true
            begin
                validation_result = upload_xml.validate_schema(schema)
            rescue
                schema_valid = false
            end

            if !schema_valid
                response_code = :bad_request
            end
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

        # See if an image already exists for this date
        if result_code == OK_CODE
            image_date_string = upload_xml.find_first('//x:image_upload/x:image/x:date', ns_string).content
            image_date = Date.parse(image_date_string)
            image_datetime = DateTime.parse(image_date_string)

            existing_image = Image.find_by_sql("SELECT * FROM images WHERE camera_id=#{camera_id} AND date='#{image_date}'")

            if existing_image.length > 0
                image_record = existing_image[0]

                if image_record.image_present?
                    result_code = IMAGE_EXISTS_CODE
                end
            end
        end

        # Decode the image data and see if we can decipher it.
        # If we can, convert it to PNG (if necessary).
        if result_code == OK_CODE
            # Extract the image data from the XML
            # This will implicitly verify that the image is valid
            begin
                image_data_encoded = upload_xml.find_first('//x:image_upload/x:image/x:file_data', ns_string).content
                image_data_unbase64 = Base64.decode64(image_data_encoded)
                image_data_decoded = Magick::Image.from_blob(image_data_unbase64)[0]


                # Convert the image to PNG if necessary
                if image_data_decoded.format != 'PNG'
                    image_data = image_data_decoded.to_blob { |attrs| attrs.format = 'PNG' }
                else
                    # Just return the original decoded data - it's a PNG blob
                    image_data = image_data_unbase64
                end
            rescue
                result_code = BAD_IMAGE_CODE
            end
        end

        # Store the image to disk and add/update the database record
        if result_code == OK_CODE
            image_path = Image.getImagePath(camera_record.id, image_date, 'png')

            # If this file exists already, there's something wrong because the
            # database doesn't think it does!
            if File.exist? image_path
                Message.createMessage(camera_record.id, MessageType.getIdFromCode("ImageFileExistsNoRecord"),
                                      false, "Image date: #{image_date}", image_data)
                result_code = UNKNOWN_ERROR_CODE
            else

                # Write the image to disk
                File.open(image_path, 'w') do |f|
                    f.write image_data
                end

                # Now update the database.
                # If the image record didn't already exist, we create it now
                if image_record.nil?
                    image_record = Image.new
                    image_record.camera_id = camera_id
                    image_record.date = image_date
                end

                # Now fill in the image details. This is time and time zome info.
                image_record.image_time = image_datetime

                camera_details = CameraDetails.find_by_camera_id(camera_id)
                if camera_details.nil?
                    Message.createMessage(camera_record.id, MessageType.getIdFromCode("MissingCameraDetails"),
                                          false, "Camera ID: #{camera_id}; while storing uploaded image", image_data)
                    result_code = UNKNOWN_ERROR_CODE
                else

                    image_record.image_present = true
                    image_record.image_time_offset_hour = camera_details.utc_offset_hour
                    image_record.image_time_offset_minute = camera_details.utc_offset_minute
                    image_record.image_daylight_saving = camera_details.daylight_saving
                    image_record.image_timezone_id = camera_details.timezone_id

                    image_record.save
                end
            end
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
