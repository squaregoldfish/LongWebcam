# Methods for interrogating the main server
#
require 'net/http'

module MainServer

    RESPONSE_OK = "200"

	def MainServer.server_up()
        server_up = true

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
                server_up = false
            elsif download_response.code != RESPONSE_OK
                server_up = false
            end
        rescue Exception
            server_up = false
        end

        return server_up
	end

end
