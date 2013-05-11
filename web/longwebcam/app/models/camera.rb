class Camera < ActiveRecord::Base
    attr_accessible :owner, :type, :url, :serial_number, :schedule, :test_camera, :licence, :upload_code, :watermark
end
