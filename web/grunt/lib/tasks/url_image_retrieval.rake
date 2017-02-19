require 'RMagick'
require 'Upload'
require 'Weather'
require 'MainServer'

namespace :lwc_grunt do
    desc "Grunt back-up URL image retrieval"
    task :url_image_retrieval => :environment do

        logger = Logger.new("log/url_image_retrieval.log")

        # Constants
        #
        RESPONSE_OK = '200'
        UPLOAD_ACCOUNT = 'LWCUpload'


        if MainServer.server_up()
            logger.info("Main server up - quitting")
        else
            logger.info("Main server down - checking for images to retrieve")

            # Work out which cameras need to have their
            # URLs retrieved.
            #
            # Loop through all the camera details
            #
            cameras_to_download = Array.new


            Camera.find_each do |details|

                # Get the current hour at the camera's location
                camera_time = Time.now.utc + details.utc_offset
                camera_hour = camera_time.hour

                # If the local time is within the download period...
                if camera_hour >= details.download_start && camera_hour < details.download_end

                    camera_id = details.camera_id

                    # See if there's been an image downloaded today
                    last_image = Images.find_by_sql("SELECT * FROM images WHERE camera_id = '#{camera_id}' ORDER BY date DESC LIMIT 1")[0]
                    if last_image == nil
                        cameras_to_download << camera_id
                    elsif last_image.date != camera_time.to_date
                        cameras_to_download << camera_id
                    end
                end
            end

            logger.info("Image required for #{cameras_to_download}")

            # Loop through each of the camera ids
            cameras_to_download.each { |camera_id|
                logger.debug("Downloading image for camera ID #{camera_id}")

                download_response = nil
                camera_record = Camera.find_by_camera_id(camera_id)
                begin

                    # Get the image URL and build the HTTP request
                    uri = URI.parse(camera_record.url)
                    http = Net::HTTP.new(uri.host, uri.port)

                    if camera_record.url.start_with?('https')
                        # You will note that we're not verifying the SSL certificate.
                        #  This is because we're on an outdated version of Ruby,
                        # and the workaround is too much hassle.
                        #
                        # Given that we're only grabbing images, this shouldn't really be a problem.
                        #
                        http.use_ssl = true
                        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                    end


                    download_request = Net::HTTP::Get.new(uri.request_uri)
                    download_response = http.request(download_request)
                rescue Exception
                    # No need to do anyting
                end

                if download_response.nil?
                    message = Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalFailure"),
                                          "URL = #{camera_record.url}; Connection Failure", nil)
                    logger.info("Download failed: #{message.to_s}")
                elsif download_response.code != RESPONSE_OK
                    message = Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalFailure"),
                                          "URL = #{camera_record.url}; HTTP Response = #{download_response.code}", nil)
                    logger.info("Download failed: #{message.to_s}")
                else
                    image_ok = true

                    # See if the downloaded document is actually an image
                    begin
                        image = Magick::Image.from_blob(download_response.body)[0]
                    rescue
                        message = Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalNotImage"),
                                              "URL = #{camera_record.url}", download_response.body)

                        logger.info("Download failed: #{message.to_s}")
                        image_ok = false
                    end

                    if image_ok

                        logger.debug("Got image for camera id #{camera_id}")

                        image_record = Images.createImageRecord(camera_id, image)

                        # Add the weather to the image record
                        logger.trace("Retrieving weather")
                        weather = Weather.new(camera_record.longitude, camera_record.latitude, camera_id)
                        weather.retrieve_data

                        if weather.data_retrieved?
                            logger.trace("Weather retrieved OK")
                            image_record.add_weather(weather)
                        end
                    end
                end
            }

        end
    end

    #######################################################################################

    desc "Upload backup retrievals to the main server"
    task :upload_backup_retrievals => :environment do

        logger = Logger.new("log/upload_backup_retrievals.log")

        if (!MainServer.server_up)
            logger.info("Main server down - quitting")
        else
            logger.info("Processing downloaded images")

            Images.all.each do |image|

                logger.info("Processing #{image.to_s}")

                # An invalid response is ignored
                image_exists = image.exists_on_server

                delete_image = false

                if image_exists != -1

                    if image_exists == 0

                        upload = Upload.new(image.camera_id, image.image_time)
                        upload.addImage(image.image_data)

                        # If image.weather_retrieved
                        weather = image.get_weather
                        unless weather.nil?
                            upload.addWeather(image.get_weather)
                        end

                        upload_response = upload.doUpload
                        if upload_response != Upload::RESPONSE_OK
                            message = Message.createMessage(image.camera_id, MessageType.getIdFromCode("ImageUploadFailure"),
                                                  false, "Response code = #{upload_response}")
                            logger.error("Image upload failed: #{message.to_s}")
                        else
                            # The image uploaded OK - we can delete it
                            delete_image = true
                        end
                    else
                        delete_image = true
                    end

                    # Delete the local image
                    if delete_image
                        logger.info("Image uploaded successfully")
                        image.destroy
                    end

                end

            end
        end
    end

    #########################################################
    desc 'Downloads camera details from the main LongWebcam server and updates the local database'
    task :update_camera_details => :environment do

        GRUNT_ACCOUNT = 'Grunt'
        RESPONSE_OK = '200'

        logger = Logger.new("log/update_camera_details.log")

        if (!MainServer.server_up)
            logger.info("Main server down - quitting")
        else
            logger.info("Updating camera details")

            # Retrieve the Camera Details XML
            url = GRUNT_CONFIG["main_url"] + "/grunt/get_camera_details"
            uri = URI.parse(url)
            http = Net::HTTP.new(uri.host, uri.port)

            if url.start_with?('https')
                # You will note that we're not verifying the SSL certificate.
                #  This is because we're on an outdated version of Ruby,
                # and the workaround is too much hassle.
                #
                # Given that we're only grabbing data, this shouldn't really be a problem.
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
                            logger.debug("New camera #{camera_id}")
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
                        database_camera.longitude = xml_camera.find_first('x:longitude', ns_string).content
                        database_camera.latitude = xml_camera.find_first('x:latitude', ns_string).content

                        # Save the camera
                        database_camera.save

                        # Remove the ID from the list of pre-existing database cameras
                        existing_cameras.delete(camera_id)
                    end

                    # Now existing_cameras just has the cameras that are no longer in the main database
                    # They can be deleted
                    existing_cameras.each do |old_camera_id|
                        logger.debug("Deleting old camera #{camera_id}")
                        Camera.find_by_camera_id(old_camera_id).destroy
                    end
                end
            end
        end
    end
end

