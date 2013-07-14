require 'xml'

class UploadController < ApplicationController
    def upload

        response_code = :ok

        # Only POSTs are allowed
        if !request.post?
            response_code = :forbidden
        else
            data_present = true
            upload_data = nil

            # Make sure the required parameter has been provided
            if !params.key?(:image_details)
                response_code = :bad_request
            else
                upload_data = params.fetch(:image_details)

                # Validate the uploaded XML against the schema
                xml = LibXML::XML::Parser.string(upload_data).parse
                schema = LibXML::XML::Schema.new("#{RAILS_ROOT}/resources/xml/image_upload.xsd")

                schema_valid = true
                begin
                    validation_result = xml.validate_schema(schema)
                rescue
                    schema_valid = false
                end


                @message = schema_valid
            end

            if response_code != :ok
                head response_code
            end
        end
    end
end
