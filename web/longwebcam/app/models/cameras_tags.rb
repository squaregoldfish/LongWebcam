class CamerasTags < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras
    belongs_to :camera_tags
end
