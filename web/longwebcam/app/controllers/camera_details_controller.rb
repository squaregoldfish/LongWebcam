require 'xml'

# THis controller returns the camera details for all URL cameras for the grunt.
# It will only work if the correct security code is supplied.
class CameraDetailsController < ApplicationController
    # This controller does not use user security, so there's no session
    skip_before_filter :verify_authenticity_token
    before_filter :init_vars

    # The SQL statement for getting the camera details required by the grunt.
    # We only want the latest set of details for each camera.
    CAMERA_SELECT_STATEMENT = "SELECT c.id, c.url, c.upload_code, " +
                "d.timezone_id, d.daylight_saving, d.utc_offset, d.download_start, d.download_end " +
                "FROM cameras c INNER JOIN camera_details d ON c.id = d.camera_id " +
                "INNER JOIN (SELECT camera_id, max(details_date) AS details_date FROM camera_details GROUP BY camera_id) m " +
                "ON d.camera_id = m.camera_id AND d.details_date = m.details_date"

    COL_CAMERA_ID = 0
    COL_URL = 1
    COL_UPLOAD_CODE = 2
    COL_TIMEZONE_ID = 3
    COL_DAYLIGHT_SAVING = 4
    COL_UTC_OFFSET = 5
    COL_DOWNLOAD_START = 6
    COL_DOWNLOAD_END = 7

    def init_vars
        @cameras = nil
    end

    def get_details
        response_code = :ok

        # Only POSTs are allowed
#        if !request.post?
#            response_code = :forbidden
#        end

        # TODO Validate passcode


        if response_code == :ok
            @cameras = ActiveRecord::Base.connection.execute(CAMERA_SELECT_STATEMENT)
        end

        if response_code != :ok
            head response_code
        else
            render :xml => self
        end
    end

    # Format the retrieved camera details as XML
    def to_xml(arg)
        # Build the XML
        output = ::Builder::XmlMarkup.new(:target => camera_xml = "")
        camera_doc = output.camera_details(:xmlns => "http://www.longwebcam.org/xml/grunt",
                                        :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                        :"xsi:schemaLocation" => "http://www.longwebcam.org/xml/grunt camera_details.xsd") {

            @cameras.each do |camera|
                output.camera { |b| b.id(camera[COL_CAMERA_ID]);
                             b.timezone_id(camera[COL_TIMEZONE_ID]);
                             b.daylight_saving(camera[COL_DAYLIGHT_SAVING]);
                             b.utc_offset(camera[COL_UTC_OFFSET]);
                             b.download_start(camera[COL_DOWNLOAD_START]);
                             b.download_end(camera[COL_DOWNLOAD_END]);
                             b.url(camera[COL_URL]);
                             b.upload_code(camera[COL_UPLOAD_CODE]);
                }
            end

        }
    end
end
