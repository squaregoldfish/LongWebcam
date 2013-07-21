require 'rubygems'
require 'date'
require 'builder'
require 'base64'

require 'net/http'

# Host name of the test server
SERVER_HOST="192.168.0.10:3000"


# Input data
cam_id = 1
upload_code = 6067
image_date = DateTime.now
format = "dlfkjg"
image_file = '3.png'



# Build request

file_content = nil

# Read the file into memory and Base64 it
File.open(image_file, "r") do|image_file|
    file_content = Base64.encode64(image_file.read)
end

#file_content = "dlkfjglkfdj"

# Build the XML
xml = Builder::XmlMarkup.new(:target => upload_xml = "")
upload_doc = xml.image_upload(:xmlns => "http://www.longwebcam.org/xml/upload",
                              :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                              :"xsi:schemaLocation" => "http://www.longwebcam.org/xml/upload") {
    xml.camera { |b| b.id(cam_id); b.code(upload_code) }
    xml.image { |b| b.date(image_date); b.type(format); b.file_data(file_content) }
}

req = Net::HTTP.post_form(URI.parse('http://' + SERVER_HOST + '/upload'), {:image_details => upload_xml})
puts req.code
puts req.body

