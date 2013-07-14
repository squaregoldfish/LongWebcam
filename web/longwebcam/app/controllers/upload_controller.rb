require 'xml'

class UploadController < ApplicationController
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

        @message = "Happy"

        if response_code != :ok
            head response_code
        end
    end
end
