class CameraDetails < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras
end
