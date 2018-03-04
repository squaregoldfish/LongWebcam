require 'xml'

# THis controller returns the camera details for all URL cameras for the grunt.
# It will only work if the correct security code is supplied.
class GruntController < ApplicationController
    # This controller does not use user security, so there's no session
    skip_before_action :verify_authenticity_token
    before_action :init_vars

    ACCOUNT_NAME = "Grunt"

    # The SQL statement for getting the camera details required by the grunt.
    # We only want the latest set of details for each camera.
    CAMERA_SELECT_STATEMENT = "SELECT c.id, c.url, c.upload_code, c.disabled, " +
                "d.timezone_id, d.daylight_saving, d.utc_offset, d.download_start, d.download_end, " +
                "d.longitude, d.latitude " +
                "FROM cameras c INNER JOIN camera_details d ON c.id = d.camera_id " +
                "INNER JOIN (SELECT camera_id, max(details_date) AS details_date FROM camera_details GROUP BY camera_id) m " +
                "ON d.camera_id = m.camera_id AND d.details_date = m.details_date"

    COL_CAMERA_ID = 0
    COL_URL = 1
    COL_UPLOAD_CODE = 2
    COL_DISABLED = 3
    COL_TIMEZONE_ID = 4
    COL_DAYLIGHT_SAVING = 5
    COL_UTC_OFFSET = 6
    COL_DOWNLOAD_START = 7
    COL_DOWNLOAD_END = 8
    COL_LONGITUDE = 9
    COL_LATITUDE = 10

    def init_vars
        @cameras = nil
    end

    def get_camera_details
        response_code = :ok

        # Only POSTs are allowed
        if !request.post?
            response_code = :forbidden
        end

        # Validate the API key
        account = Account.find_by_account(ACCOUNT_NAME)
        if (account.api_key != params.fetch(:api_key))
            response_code = :forbidden
        end

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
        camera_doc = output.camera_details(:xmlns => APP_CONFIG["base_url"] + "/xml/camera_details",
                                        :"xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                                        :"xsi:schemaLocation" => APP_CONFIG["grunt_url"] + "xml/camera_details.xsd") {

            @cameras.each do |camera|
                output.camera { |b| b.id(camera[COL_CAMERA_ID]);
                             if camera[COL_DISABLED] == 1
                                b.disabled("true");
                             else
                                b.disabled("false");
                             end
                             b.timezone_id(camera[COL_TIMEZONE_ID]);
                             b.daylight_saving(camera[COL_DAYLIGHT_SAVING]);
                             b.utc_offset(camera[COL_UTC_OFFSET]);
                             b.download_start(camera[COL_DOWNLOAD_START]);
                             b.download_end(camera[COL_DOWNLOAD_END]);
                             b.url(camera[COL_URL]);
                             b.upload_code(camera[COL_UPLOAD_CODE]);
                             b.longitude(camera[COL_LONGITUDE]);
                             b.latitude(camera[COL_LATITUDE]);
                }
            end
        }
    end

    # Simply return a 200 response
    def ping()
        head :ok
    end

    # See if an image from the specified camera/date exists.
    # Returns a 1 or 0 in the response body
    def image_exists()

        response_code = :ok
        camera_id = nil
        date = nil
        image_exists = false

        # Only POSTs are allowed
        if !request.post?
            response_code = :forbidden
        end

        if response_code == :ok

            camera_id = params[:camera_id]
            date = params[:date]

            if camera_id.nil? || date.nil?
                response_code = :bad_request
            else
                image = Image.getImageRecord(camera_id, date)
                image_exists = !image.nil?
            end
        end

        if response_code != :ok
            head response_code
        else
            render :body => image_exists
        end
    end
end
