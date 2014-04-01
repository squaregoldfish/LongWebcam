set :output, "/home/lwcdev/git/LongWebcam/web/longwebcam/log/whenever.log"

# URL Camera Retrieval
every 5.minutes do
    rake "lwc:url_image_retrieval"
end

