class CamerasEvents < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
    belongs_to :events
end
