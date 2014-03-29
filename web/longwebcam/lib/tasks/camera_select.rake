namespace :lwc do
    desc "Select cameras for URL download"
    task :camera_select => :environment do

        logger = Logger.new("log/camera_select.log")

        cameras_to_download = Array.new

        # Loop through all the camera details
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

        logger.debug(cameras_to_download)
    end
end

