require 'builder'

# The response codes and messages for image uploads
# are stored in the database so they can be tweaked
# easily.
#
# This is the model class for the responses. Its only
# function is to render the response in the correct XML
# format.
#
class UploadResponse < ActiveRecord::Base
    attr_accessible

    def to_xml
        xml = Builder::XmlMarkup.new(:target => response_xml = "")
        response_doc = xml.upload_response(:xmlns => "http://www.longwebcam.org/xml/upload_response",
                                           :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                           :"xsi:schemaLocation" => "http://www.longwebcam.org/xml/upload_response upload_response.xsd") { |b|
            b.code(self.code);
            b.message(self.message)
        }

        return response_xml
    end
end
