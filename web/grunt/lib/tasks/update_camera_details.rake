namespace :lwc_grunt do

    desc 'Downloads camera details from the main LongWebcam server and updates the local database'
    task :update_camera_details => :environment do

        GRUNT_ACCOUNT = 'Grunt'
        RESPONSE_OK = '200'

        logger = Logger.new("log/update_camera_details.log")


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
            p response.body
        end
    end
end