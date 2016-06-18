require 'xml'

namespace :lwc_grunt do

    desc 'Downloads camera details from the main LongWebcam server and updates the local database'
    task :update_camera_details => :environment do

        GRUNT_ACCOUNT = 'Grunt'
        RESPONSE_OK = '200'

        logger = Logger.new("log/update_camera_details.log")


        # Retrieve the Camera Details XML
        url = GRUNT_CONFIG["main_url"] + "/grunt/get_camera_details"
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
        request.set_form_data({"api_key" => GRUNT_CONFIG["grunt_api_key"]})

        response = http.request(request)

        if response.nil?
            logger.fatal("Empty response from server")
        elsif response.code != RESPONSE_OK
            logger.error("Non-OK response from server: " + response.code)
        else
            camera_xml = LibXML::XML::Parser.string(response.body).parse

            # Validate the XML
            schema = LibXML::XML::Schema.new("#{Rails.root}/public/xml/camera_details.xsd")

            schema_valid = true
            # begin
            #    validation_result = camera_xml.validate_schema(schema)
            # rescue
            #    schema_valid = false
            # end

#            if !schema_valid
#                logger.error "Upload XML invalid"
#            end

            if schema_valid

                # Record the retrieval time
                retrieval_time = Time.now.utc

                # Set up the namespace info
                ns_string = "x:" + GRUNT_CONFIG["main_url"] + "/xml/camera_details"

                # Find the camera record
                # camera_id = camera_xml.find_first('//x:camera_details/x:camera/x:id', ns_string).content

                # Get all the camera IDs already in the database
                existing_cameras = Camera.pluck(:camera_id)

                # Loop through each camera in the XML
                xml_cameras = camera_xml.find('//x:camera_details/x:camera', ns_string).each do |xml_camera|

                    camera_id = Integer(xml_camera.find_first('x:id', ns_string).content)

                    database_camera = Camera.find_by_camera_id(camera_id)

                    # Create the record if it doesn't exist
                    if (database_camera.nil?)
                        database_camera = Camera.new
                        database_camera.camera_id = camera_id
                    end

                    # Set all the fields
                    database_camera.retrieved = retrieval_time
                    database_camera.timezone_id = xml_camera.find_first('x:timezone_id', ns_string).content
                    database_camera.daylight_saving = xml_camera.find_first('x:daylight_saving', ns_string).content
                    database_camera.utc_offset = xml_camera.find_first('x:utc_offset', ns_string).content
                    database_camera.download_start = xml_camera.find_first('x:download_start', ns_string).content
                    database_camera.download_end = xml_camera.find_first('x:download_end', ns_string).content
                    database_camera.url = xml_camera.find_first('x:url', ns_string).content
                    database_camera.upload_code = xml_camera.find_first('x:upload_code', ns_string).content

                    # Save the camera
                    database_camera.save

                    # Remove the ID from the list of pre-existing database cameras
                    existing_cameras.delete(camera_id)
                end

                # Now existing_cameras just has the cameras that are no longer in the main database
                # They can be deleted
                existing_cameras.each do |old_camera_id|
                    Camera.find_by_camera_id(old_camera_id).destroy
                end
            end
        end
    end
end