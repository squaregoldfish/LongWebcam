require 'RMagick'
require 'Upload'
require 'Weather'

namespace :lwc_grunt do
    desc "Grunt back-up URL image retrieval"
    task :url_image_retrieval => :environment do

        logger = Logger.new("log/url_image_retrieval.log")

        # Constants
        #
        RESPONSE_OK = '200'
        UPLOAD_ACCOUNT = 'LWCUpload'

        main_server_up = true

        # See if the main server is up. If it is,
        # we don't need to do anything
        ping_url = GRUNT_CONFIG["main_url"] + "/grunt/ping"
        uri = URI.parse(ping_url)
        http = Net::HTTP.new(uri.host, uri.port)

        if ping_url.start_with?('https')
            # You will note that we're not verifying the SSL certificate.
            #  This is because we're on an outdated version of Ruby,
            # and the workaround is too much hassle.
            #
            # Given that we're only grabbing images, this shouldn't really be a problem.
            #
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end

        begin
            download_request = Net::HTTP::Post.new(uri.request_uri)
            download_response = http.request(download_request)

            if download_response.nil?
                main_server_up = false
            elsif download_response.code != RESPONSE_OK
                main_server_up = false
            end
        rescue Exception
            main_server_up = false
        end

        if !main_server_up

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

            p cameras_to_download

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
                    Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalFailure"),
                                          "URL = #{camera_record.url}; Connection Failure", nil)
                elsif download_response.code != RESPONSE_OK
                    Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalFailure"),
                                          "URL = #{camera_record.url}; HTTP Response = #{download_response.code}", nil)
                else
                    image_ok = true

                    # See if the downloaded document is actually an image
                    begin
                        image = Magick::Image.from_blob(download_response.body)[0]
                    rescue
                        Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalNotImage"),
                                              "URL = #{camera_record.url}", download_response.body)

                        image_ok = false
                    end

                    if image_ok

                        p "Got image for camera id #{camera_id}"

                        image_record = Images.createImageRecord(camera_id, image)

                        # Add the weather to the image record
                        weather = Weather.new(camera_record.longitude, camera_record.latitude, camera_id)
                        weather.retrieve_data

                        if weather.data_retrieved?
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

        Images.all.each do |image|

            # An invalid response is ignored
            image_exists = image.exists_on_server

            delete_image = false

            if image_exists != -1

                if image_exists == 0

                    upload = Upload.new(image.camera_id, image.image_time)
                    upload.addImage(image.image_data)

                    # If image.weather_retrieved
                    upload.addWeather(image.get_weather)

                    upload_response = upload.doUpload
                    if upload_response != Upload::RESPONSE_OK
                        Message.createMessage(camera_id, MessageType.getIdFromCode("ImageUploadFailure"),
                                              false, "Response code = #{upload_response}", download_response.body)
                    else
                        # The image uploaded OK - we can delete it
                        delete_image = true
                    end
                else
                    delete_image = true
                end

                # Delete the local image
                if delete_image
                    image.destroy
                end

            end

        end

    end
end

