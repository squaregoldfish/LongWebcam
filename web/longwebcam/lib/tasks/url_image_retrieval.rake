require 'RMagick'
require 'Upload'
require 'Weather'

namespace :lwc do
    desc "Retrieves URL-based camera images and weather"
    task :url_image_retrieval => :environment do

        # Constants
        #
        RESPONSE_OK = '200'
        UPLOAD_ACCOUNT = 'LWCUpload'

        # Work out which cameras need to have their
        # URLs retrieved.
        #
        # Loop through all the camera details
        #
        cameras_to_download = Array.new


        CameraDetails.find_each do |details|

            # Get the current hour at the camera's location
            camera_time = Time.now.utc + details.utc_offset
            camera_hour = camera_time.hour

            # If the local time is within the download period...
            if camera_hour >= details.download_start && camera_hour < details.download_end

                camera_id = details.camera_id

                # See if there's been an image downloaded today
                last_image = Image.find_by_sql("SELECT * FROM images WHERE camera_id = '#{camera_id}' ORDER BY date DESC LIMIT 1")[0]
                if last_image == nil
                    cameras_to_download << camera_id
                elsif last_image.date != camera_time
                    cameras_to_download << camera_id
                end
            end
        end


        # Loop through each of the camera ids
        cameras_to_download.each { |camera_id|

            # Get the image URL and build the HTTP request
            camera_record = Camera.find_by_id(camera_id)
            camera_details = CameraDetails.find_by_camera_id(camera_id)
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

            # Send the request
            download_response = http.request(download_request)

            if download_response.code != RESPONSE_OK
                Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalFailure"),
                                      true, "URL = #{camera_record.url}; HTTP Response = #{download_response.code}", nil)
            else
                image_ok = true

                # See if the downloaded document is actually an image
                begin
                    image = Magick::Image.from_blob(download_response.body)[0]
                rescue
                    Message.createMessage(camera_id, MessageType.getIdFromCode("URLRetrievalNotImage"),
                                          true, "URL = #{camera_record.url}", download_response.body)

                    image_ok = false
                end

                if image_ok
                    # Create the upload object and add the image to it
                    image_date = DateTime.now
                    upload = Upload.new(camera_id, image_date)
                    upload.addImage(download_response.body)

                    # Download the weather and add it to the upload object
                    #
                    weather = Weather.new(camera_details.longitude, camera_details.latitude, camera_id)
                    weather.retrieve_data

                    if weather.data_retrieved?
                        upload.addWeather(weather)
                    end

                    # Send the upload
                    upload_response = upload.doUpload
                    if upload_response != Upload::RESPONSE_OK
                        Message.createMessage(camera_id, MessageType.getIdFromCode("ImageUploadFailure"),
                                              false, "Response code = #{upload_response}", download_response.body)
                    end
                end
            end

        }
        end
    end

