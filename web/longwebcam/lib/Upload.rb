require 'xml'
require 'base64'

# Class for handling the upload of images.
class Upload

    # CONSTANTS
    ACCOUNT_NAME = "LWCUpload"
    RESPONSE_OK = '200'

    # Constructor - stores passed in info and retrieves additional
    # required details
    #
    def initialize(camera_id, image_date, image_data)

        # Store the passed in values in instance variables
        @camera_id = camera_id
        @image_date = image_date
        @image_data = image_data

        # Retrieve the camera's upload code
        #
        camera_record = Camera.find_by_id(camera_id)
        @upload_code = camera_record.upload_code

        @uploadResponseXML = nil
    end

    # Upload the image to the LWC Server for storage.
    # Returns the code from the upload - either the code
    # from the XML response to the upload, or the HTTP response code
    # if there's no returned XML.
    #
    def doUpload()
        upload_account = Account.find_by_account(ACCOUNT_NAME)
        req = Net::HTTP.post_form(URI.parse(upload_account.url + upload_account.path), {:image_details => buildXML()})

        response_code = req.code

        if req.code == '200'
            @uploadResponseXML = req.body
            response_code = extractXMLRepsonseCode()
        end

        return response_code
    end

    # Return the full response XML
    def uploadResponseXML
        @uploadResponseXML
    end


    ##############################################
    private

    # Build the upload XML document for this upload instance
    #
    def buildXML()
        xml = Builder::XmlMarkup.new(:target => upload_xml = "")
        upload_doc = xml.image_upload(:xmlns => "http://www.longwebcam.org/xml/upload",
                                      :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                      :"xsi:schemaLocation" => "http://www.longwebcam.org/xml/upload") {
        xml.camera { |b| b.id(@camera_id); b.code(@upload_code) }
        xml.image { |b| b.date(@image_date); b.file_data(Base64.encode64(@image_data)) }
        }

        return upload_xml
    end

    # Extract the response code from the XML returned by the upload request
    #
    def extractXMLRepsonseCode()
        code = nil

        puts @uploadResponseXML

        if !@uploadResponseXML.nil?
            parsed_xml = LibXML::XML::Parser.string(@uploadResponseXML).parse
            schema = LibXML::XML::Schema.new("#{RAILS_ROOT}/resources/xml/upload_response.xsd")

            begin
                validation_result = parsed_xml.validate_schema(schema)

                ns_string = "x:http://www.longwebcam.org/xml/upload_response"
                code = parsed_xml.find_first('//x:upload_response/x:code', ns_string).content
            rescue
                raise IOError, "Upload Repsonse XML is not valid"
            end
        end

        return code
    end
end
