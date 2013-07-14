require 'xml'

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
        upload_data = nil

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
            xml = LibXML::XML::Parser.string(upload_data).parse
            schema = LibXML::XML::Schema.new("#{RAILS_ROOT}/resources/xml/image_upload.xsd")

            schema_valid = true
            begin
                validation_result = xml.validate_schema(schema)
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
