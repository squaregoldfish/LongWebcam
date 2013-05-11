class CameraDetails < ActiveRecord::Base
    attr_accessible :camera_id, :details_date, :longitude, :latitude, :bearing, :ground_height, :camera_height, :manufacturer, :model, :resolution_x, :resolution_y
end
