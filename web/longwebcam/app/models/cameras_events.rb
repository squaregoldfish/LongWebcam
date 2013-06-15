class CamerasEvents < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras
    belongs_to :events
end
