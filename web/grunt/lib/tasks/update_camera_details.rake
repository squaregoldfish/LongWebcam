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
            begin
                validation_result = camera_xml.validate_schema(schema)
            rescue
                schema_valid = false
            end

#            if !schema_valid
#                logger.error "Upload XML invalid"
#                response_code = :bad_request
#            end

            # Set up the namespace info
            ns_string = "x:" + GRUNT_CONFIG["main_url"] + "/xml/camera_details"

            # Find the camera record
            camera_id = camera_xml.find_first('//x:camera_details/x:camera/x:id', ns_string).content

            p camera_id


        end
    end
end