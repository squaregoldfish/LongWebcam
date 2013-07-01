require 'rubygems'
require 'date'
require 'builder'
require 'base64'

# Host name of the test server
SERVER_HOST="192.168.0.10:3000"

# Get the upload details
print "Camera ID: "
cam_id = gets.strip

print "Upload code: "
upload_code = gets.strip

print "Image date (yyyymmddhhmmss): "
input_date = gets.strip
image_date = DateTime.parse(input_date)

print "Image format: "
format = gets.strip

print "Image file: "
image_file = gets.strip

file_content = nil

# Read the file into memory and Base64 it
File.open(image_file, "r") do|image_file|
    file_content = Base64.encode64(image_file.read)
end

# Build the XML
xml = Builder::XmlMarkup.new
upload_doc = xml.image_upload {
    xml.camera { |b| b.id(cam_id); b.code(upload_code) }
    xml.image { |b| b.date(image_date); b.type(format); b.file_data(file_content) }
}


